#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
source env.sh

set -ex

apt-get upgrade -y
apt-get dist-upgrade -y

apt-get install -y curl

curl --connect-timeout 2 -m 4 -s https://t.co >/dev/null || GFW=1

apt-get install -y glances unzip build-essential musl-tools g++ git bat jq libffi-dev zlib1g-dev liblzma-dev libssl-dev pkg-config git-lfs libreadline-dev libbz2-dev libsqlite3-dev libzstd-dev zsh protobuf-compiler software-properties-common wget cmake autoconf automake libtool clang sd xtail

apt-get install -y mold
export RUSTFLAGS="-C linker=clang -C link-arg=-fuse-ld=/usr/bin/mold"

chsh -s /bin/zsh root
apt remove --purge --assume-yes snapd gnome-software-plugin-snap
apt autoremove -y
git lfs install

if ! command -v mosh &>/dev/null; then
  git clone --depth=1 https://$([ $GFW ] && echo gitee.com/mirrors || echo github.com/mobile-shell)/mosh.git
  cd mosh && ./autogen.sh && ./configure
  make && make install && cd .. && rm -rf mosh
fi

if ! command -v nvim &>/dev/null; then
  add-apt-repository -y ppa:neovim-ppa/unstable
  apt-get update
  apt-get install -y neovim
fi

RS=sh.rustup.rs
CARGO_INSTALL="cargo binstall --no-confirm"

[ $GFW ] &&
  CARGO_INSTALL="cargo install" &&
  RS=rsproxy.cn/rustup-init.sh &&
  export RUSTUP_DIST_SERVER="https://rsproxy.cn" &&
  export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup" &&
  git config --global url."https://mirror.ghproxy.com/https://github.com".insteadOf "https://github.com"

CURL="curl --connect-timeout 5 --max-time 10 --retry 9 --retry-delay 0 -sSf"

$CURL https://$RS | sh -s -- -y --no-modify-path --default-toolchain nightly

source $CARGO_HOME/env

rustup component add rust-analyzer

cargo install --root /usr/local --git https://github.com/3tifork/ripgrep.git

cargo install cargo-binstall

cargo_install() {
  for i in "$@"; do
    $CARGO_INSTALL --root /usr/local $i
  done
}

# 这样方便调试, 有时候 github action 会在这一步卡死
cargo_install atuin stylua erdtree cargo-cache tokei diskus cargo-edit cargo-update rtx-cli wasm-bindgen-cli eza watchexec-cli fd-find wasm-pack

arch=$(uname -m)

eval $(rtx env)

rm -rf $CARGO_HOME/registry

rustup target add wasm32-unknown-unknown
cargo-cache --remove-dir all

cd $CARGO_HOME

rm -rf config
ln -s ~/.cargo/config .

$DIR/rtxi.sh nodejs
$DIR/rtxi.sh golang
$DIR/rtxi.sh python

eval $(rtx env)

[ $GFW ] &&
  go env -w GOPROXY=https://goproxy.cn,direct

go install github.com/evilmartians/lefthook@latest &
go install github.com/charmbracelet/glow@latest &
go install mvdan.cc/sh/cmd/shfmt@latest &
go install github.com/muesli/duf@master &
go install github.com/louisun/heyspace@latest &

rm -rf czmod
if ! command -v czmod &>/dev/null; then
  git clone --depth=1 https://github.com/skywind3000/czmod.git
  cd czmod
  ./build.sh && mv czmod /usr/local/bin
  rm -rf czmod
fi

wait
cd ..

[ -f /opt/bun/bin/bun ] || $CURL https://bun.sh/install | bash

cd /usr/local
wget https://$([ $GFW ] && echo gitee.com/mirrors/fzf/raw || echo raw.githubusercontent.com/junegunn/fzf)/master/install -O fzf.install.sh
yes | bash ./fzf.install.sh && rm ./fzf.install.sh && cd ~
