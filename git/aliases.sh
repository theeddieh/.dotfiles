#!/usr/bin/env bash

# this is pretty roundabout to gt the formatting right...
print_git_aliases()  {
    (   
        echo "[ALIAS]" "[COMMAND]"
        git config --global --get-regexp alias.* \
            | sed 's/alias.//' \
            | sed 's/ /X/g' \
            | sed 's/X/ /'
    ) \
        | sort \
        | column -t \
        | sed 's/X/ /g'
}

alias git=hub
alias g=git
