#!/usr/bin/env bash

alias g=git
# alias h=hub

# this is pretty roundabout to get the formatting right...
print_git_aliases()  {
    (   
        echo "[ALIAS]" "[COMMAND]"
        git config --global --get-regexp alias.* \
            | sed 's/alias.//' \
            | sed 's/ /X/g' \
            | sed 's/X/ /'
    ) \
        | column -t \
        | sed 's/X/ /g'
}

list_status() {
    git status --short \
        | awk {'printf(" %s \n", $1); printf("\n|%s|\n", $0)'}
}

refresh_main() {
    branch=$(git symbolic-ref --short HEAD)
    git checkout main
    git fetch origin
    git merge origin/main --ff-only
    git checkout ${branch}
}

is_commit_signed() {
    commit=${1:-"HEAD"}
    git verify-commit ${commit} &> /dev/null
    echo $?
}

list_signed_commits() {
    num=${1:-"10"}
    hashes=$(git log --pretty=format:'%h' -${num})

    for hash in ${hashes[@]}; do
        if [[ "$(is_commit_signed ${hash})" == "0" ]]; then
            echo "🔐    ${hash}"
        else
            echo "⚠️    ${hash}"
        fi
    done
}
