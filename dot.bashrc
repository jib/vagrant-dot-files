# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.dot_files/aliases, instead of adding them here directly.
# See /usr/share/doc.dot_files-doc/examples in the.dot_files-doc package.

if [ -f ~/.dot_files/aliases ]; then
    . ~/.dot_files/aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash/bash.basrc).
if [ -f ~/.dot_files/etc/bash_completion ] && ! shopt -oq posix; then
    . ~/.dot_files/etc/bash_completion
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

### Any env settings?
if [ -f ~/.dot_files/env ]; then
    . ~/.dot_files/env
fi

### Any additional files to source
if [ -f ~/.dot_files/source ]; then
    . ~/.dot_files/source
fi

### Perl settings
if [ -f ~/.dot_files/perl ]; then
    . ~/.dot_files/perl
fi
