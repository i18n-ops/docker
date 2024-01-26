#!/usr/bin/env zsh

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

declare -A ZINIT
ZINIT[HOME_DIR]=/opt/zinit
source env.sh

mkdir -p /opt/zinit

if [ -d "$ZINIT_HOME" ]; then
  git -C $ZINIT_HOME pull
else
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME
fi

cat /root/.zinit.zsh | grep --invert-match "^zinit ice" | zsh

/opt/zinit/plugins/romkatv---powerlevel10k/gitstatus/install
