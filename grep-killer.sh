#!/bin/sh

set -e

here=`dirname $0`

regexp="$1"
if [ -z "$regexp" ]
then
    echo "Missing regexp to match tool output. Example '^kill me\$'." >&2
    exit 1
fi
shift

tool="$1"
if [ -z "$tool" ]
then
    echo "Missing executable to be run, maybe $0 '^kill me\$' ./tool-mockup.sh?" >&2
    exit 1
fi
shift

read_till_match() {
    while IFS= read -r line
    do
        if echo "$line" | egrep "$regexp" > /dev/null
        then
            echo "This <<$line>> is matched by <<$regexp>>, job done."
            exit
        fi
        echo "$line"
    done
}

tool_pid=
child_finished() {
    echo "Some child finished."
    [ -z "$tool_pid" ] || kill "$tool_pid" 2> /dev/null || true
    tool_pid=
}
trap child_finished SIGCHLD

$tool "$@" > >(read_till_match) &
tool_pid=$!
wait || true
echo DONE
