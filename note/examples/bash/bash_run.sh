#!/bin/bash

if [ -n "$SOMEPATH" ]; then
    echo $SOMEPATH
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# blah blah
exec=${1?"Must specify first arg"}
shift

# exec -a for tmux to get name.. maybe not needed
exec -a $(basename $exec) $exec "$@"
