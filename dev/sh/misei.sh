#!/usr/bin/env bash

set -ex
mise install $1@latest
last=$(mise ls --json $1 | jq -r 'last(.[] | .version)')
mise global $1@$last
mise list $1 | tail -n +1 | head -n -1 | awk '{print $2}' | xargs -I {} mise remove $1@{}
