#!/bin/bash

if ! grep "Arch Linux" /etc/os-release &> /dev/null; then
  echo "This script should run under Arch Linux"
  exit 1
fi

. /usr/share/makepkg/util.sh
colorize

prefix="https://raw.githubusercontent.com"

declare -A resources
resources=(
  ["$HOME/.vimrc"]="Avimitin/Avimitin/master/.vimrc"
  ["$HOME/.bashrc"]="Avimitin/Avimitin/master/.bashrc"
  ["$HOME/.tmux.conf"]="Avimitin/tmux/master/.tmux.conf.min"
)

declare -A sha256sums
sha256sums=(
  ["$HOME/.vimrc"]="08a84017c3c32f61dac8e3bda2bda60774c5e94fdc1c60f2b4add65f8bfa9364"
  ["$HOME/.bashrc"]="e4e3b54204e04359f88e421d3fe43a962ac28e2becb6bf0cc19c44672c890f8e"
  ["$HOME/.tmux.conf"]="5f67c6b7221b57e695068f5c412794509ca89864901f808b0c203a6cf4b37b86"
)

for output in ${!resources[@]}; do
  remote="${prefix}/${resources[$output]}"
  msg "Downloaing $output..."

  curl -sSfLo "$output" "$remote"

  msg2 "Checking file integrity..."
  sum="${sha256sums[$output]}"
  echo "$sum  $output" | sha256sum --check --status
  if (( $? != 0 )); then
    error "$output sha256sums mismatch, file might broken"
    exit 1
  fi
done

msg "Creating cache directory"
mkdir -p $HOME/.cache/rvpkg

msg "Creating workspace"
mkdir -p $HOME/rvpkg
