#!/bin/sh

set -e

here=`dirname $0`

while IFS= read -r line
do
    echo "$line"
    sleep 1
done < $here/tool-output.txt
