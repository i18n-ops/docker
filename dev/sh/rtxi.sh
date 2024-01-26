#!/usr/bin/env bash

set -ex
rtx install $1@latest
last=$(rtx ls --json $1 | jq -r 'last(.[] | .version)')
rtx global $1@$last
rtx list $1 | tail -n +1 | head -n -1 | awk '{print $2}' | xargs -I {} rtx remove $1@{}
