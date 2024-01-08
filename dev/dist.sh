#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

./gen.sh zh
./build.sh
./gen.sh en
./build.sh
