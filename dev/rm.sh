#!/usr/bin/env bash

set -ex
name=i18nsite
docker stop $name
docker rm $name
