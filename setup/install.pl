#!/usr/bin/perl
use strict;
use warnings;

use FindBin         qw[$Bin];

use Term::UI;
use Getopt::Long;

my $help    = 0;
my $yes     = 0;
my $auto    = 0;
my $force   = 0;
my $dir     = $ENV{'HOME'};

my %opts        = (
    help            => \$help,
    yes             => \$yes,
    force           => \$force,
    "no-prompt"     => \$auto,
    dir             => \$dir,
);

GetOptions( %opts ) or die usage( %opts );

my $target  = "$dir/.dot_files";
my $term    = Term::ReadLine->new('Install Dot Files');

print <<".";
**************************************************
Working on home dir: $dir
**************************************************

.

### Copy files in place
{   my $source = "$Bin/../";

    ### already copied?
    next if -d $target and !$force;

    my $bool = do {
        local $Term::UI::AUTOREPLY = $auto;
        $term->ask_yn( prompt => "Copy files to $target?", default => $yes );
    };

    if( $bool ) {
        print "Copying files\n\n\n";
        system( qq[ cp -R $source/ $target ] ) and die $?;
    }
}

### remove crappy bash profile
{   my $file = "$dir/.bash_profile";

    ### if it's already gone, don't worry about it
    next unless -e $file and !$force;

    print "$file prevents .bash_rc from being executed. Remove it?\n";

    my $bool = do {
        local $Term::UI::AUTOREPLY = $auto;
        $term->ask_yn( prompt => "Unlink $file?", default => $yes );
    };

    if( $bool ) {
        print "Unlinking $file\n\n\n";
        unlink $file;
    }
}

### load bash options
{   my $file    = "$dir/.bashrc";
    my $rc      = "$target/dot.bashrc";

    ### tripple escape $PATH, so the system echo doesn't expand it.
    my $snippet = qq[
### Include custom options
if [ -f $rc ]; then
    . $rc
fi

PATH=\\\$PATH:$target/bin

];

    ### already included?
    next if not system( qq[grep -q $rc $file] ) and not $force;

    my $bool = do {
        local $Term::UI::AUTOREPLY = $auto;
        $term->ask_yn( prompt => "Source $rc?", default => $yes );
    };

    if( $bool ) {
        system( qq[ echo "$snippet" >> $file ] ) and die $?;
    }
}

sub usage {
    my %args  = @_;
    my $usage = qq[
  Usage: $0 [--OPTS]

    \n];

    for my $key ( sort keys %args ) {
        $usage .= sprintf( "    %-15s # Default: %s\n", $key, ${$args{$key}} );
    }
    return $usage;
}


