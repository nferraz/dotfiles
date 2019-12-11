#!/bin/bash

# Source global profile
if [ -f /etc/profile ]; then
    . /etc/profile
fi

# Enable colors for ls
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# disable line wrapping
export LESS='FRX'

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# Homebrew
if type brew &>/dev/null; then
    export PATH="/usr/local/bin:$PATH"

    # GNU Command Line Tools
    BREW_PREFIX=$(brew --prefix)
    export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="$BREW_PREFIX/opt/grep/libexec/gnubin:$PATH"

    if [ -f $BREW_PREFIX/etc/bash_completion ]; then
    . $BREW_PREFIX/etc/bash_completion
    fi
fi

export EDITOR='vim'
export GIT_OPEN='vim'

# local::lib
if [ -d ~/perl5 ]; then
    eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
    export PATH="$HOME/perl5/bin:$PATH"
fi

# Source prompt
if [ -f ~/.prompt ]; then
    . ~/.prompt
fi

# Source aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
