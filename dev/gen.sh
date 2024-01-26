#!/usr/bin/env bash

DIR=$(
  cd "$(dirname "$0")"
  pwd
)
cd $DIR

set -ex

os=${1:-'en'}

cat build/head >Dockerfile
cat build/$os/Dockerfile >>Dockerfile
cat build/Dockerfile >>Dockerfile

end=build/$os/end

if [ -f "$end" ]; then
  cat $end >>Dockerfile
fi

cat build/end >>Dockerfile
