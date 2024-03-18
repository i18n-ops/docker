#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

DOCKER_ORG=${DOCKER_ORG:-'i18nsite'}

dist() {
  os=$1
  ./gen.sh $os
  ./build.sh $os
  docker push -a $DOCKER_ORG/dev_$os
}

dist zh
dist en
