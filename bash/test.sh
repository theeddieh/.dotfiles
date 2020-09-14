#!/usr/bin/env bash

set -euo pipefail

DIR="$( dirname "$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)")"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN env var is not set"
    exit 1
fi

show_usage() {
    echo "this: a script"
    echo
    echo "Usage:"
    echo "  ./this [command]"
    echo
    echo "Commands:"
    echo "  help        print this help message"
}

command=${1:-"help"}
case ${command} in
    'dir')
        echo ${DIR}
        ;;
    '-h' | 'help')
        show_usage
        ;;
    *)
        echo "unrecognized command: ${command}"
        show_usage
        ;;
esac
