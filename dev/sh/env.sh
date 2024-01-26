set -o allexport
DEBIAN_FRONTEND=noninteractive
BUN_INSTALL=/opt/bun
TERM=xterm-256color
RTX_DATA_DIR=/opt/rtx
RTX_CACHE_DIR=/cache/rtx
CARGO_HOME=/opt/rust
RUSTUP_HOME=/opt/rust
PNPM_HOME=/opt/pnpm
ZINIT_HOME=/opt/zinit/zinit.git
ZPFX=/opt/zinit/polaris
PATH="$PNPM_HOME:$PATH"
set +o allexport
