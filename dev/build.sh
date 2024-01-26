#!/usr/bin/env bash

DOCKER_ORG=${DOCKER_ORG:-'i18nsite'}
os=${1:-'en'}

# ./gen.sh $os

DIR=$(
  cd "$(dirname "$0")"
  pwd
)
cd $DIR

set -ex

tag=$(date +%Y-%m-%d)
img=$DOCKER_ORG/dev_$os
docker buildx build -t $img:$tag -t $img:latest -f Dockerfile .
rm -rf Dockerfile
