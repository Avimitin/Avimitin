#!/bin/bash

(source /etc/os-release && \
  [[ "$NAME" != "Arch Linux" ]] && \
  echo "Invalid distribution, expect Arch Linux" && \
   exit 1)

if [[ -z "$LIBMAKEPKG_UTIL_SH" ]]; then
  source /usr/share/makepkg/util.sh
  colorize
fi

exist() {
  local not_present=0
  local args=$@
  for pkg in ${args[@]}; do
    if ! command -v $pkg &> /dev/null; then
      not_present=1
    fi
  done
  return $not_present
}

if ! exist cargo; then
  sudo pacman -S rust
fi

build_flags=(
  "--release"
  "--jobs $(nproc)"
)
binaries=(
  archrv_patch_dl
)
install_path="$HOME/.local/bin/"

mkdir -p $install_path

for bin in ${binaries[@]}; do
  cargo build ${build_flags[@]} --bin $bin
  cp target/release/$bin $install_path
done
