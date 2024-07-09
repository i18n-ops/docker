#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

source env.sh

set -ex

export PATH=/opt/bun/bin:$PATH

cd $(mktemp -d)

bun i -g @biomejs/biome prettier-pnp
touch 1.pug
bun x prettier-pnp --pnp @prettier/plugin-pug --stdin-filepath 1.pug || true
rm 1.pug
touch 1.toml
bun x prettier-pnp --pnp prettier-plugin-toml --stdin-filepath 1.toml || true
rm 1.toml

cd $DIR

eval $(mise env)

npm install -g pnpm

for pkg in $(cat ~/.default-npm-packages); do
  if [ -n "$pkg" ]; then
    pnpm i -g $pkg &
  fi
done

pip install -r ~/.default-python-packages

update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 1
update-alternatives --set vi /usr/bin/nvim
update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 1
update-alternatives --set vim /usr/bin/nvim
update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 1
update-alternatives --set editor /usr/bin/nvim
curl -fLo /etc/vim/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

wait

eval $(mise env)

vi -E -u /etc/vim/sysinit.vim +PlugInstall +qa
vi -u /etc/vim/sysinit.vim +UpdateRemotePlugins +qa
vi +'CocInstall -sync coc-biome coc-rust-analyzer coc-json coc-yaml coc-css coc-python coc-vetur coc-svelte' +qa

if [ "$(uname -m)" != "aarch64" ]; then
  vi +'CocInstall -sync coc-tabnine' +qa
fi

find /etc/vim -type d -exec chmod 755 {} +

apt-get install -y \
  ncdu asciinema man lua5.4 pdsh \
  tzdata sudo tmux openssh-client libpq-dev \
  rsync plocate gist less util-linux apt-utils \
  htop cron bsdmainutils universal-ctags rclone \
  direnv iputils-ping dstat zstd git-extras \
  aptitude clang-format openssh-server

ldconfig

rm -rf /root/.cache/pip
python -m pip cache purge
go clean --cache
npm cache clean -f
pnpm store prune || true
apt-get clean -y

cd /
fd __pycache__ --no-ignore -t directory | grep -v /snapshot/ | xargs -I {} rm -rf {}

mkdir -p /init/etc/rc.d && mv /etc/rc.d/* /init/etc/rc.d
sed -i 's/^#*\s*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#*\s*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i "s/#ClientAliveInterval 0/ClientAliveInterval 60/g" /etc/ssh/sshd_config
sed -i "s/#ClientAliveCountMax 3/ClientAliveCountMax 3/g" /etc/ssh/sshd_config
rm -rf /root/.npm /root/.launchpadlib
mkdir -p /root/.npm
#echo "cp -r /init/* / && exec zsh" > /root/.zshrc
#rm -rf /var/lib/apt/lists /var/tmp /tmp /var/log /var/cache/debconf /root/.npm
