#!/bin/sh

set -e

colorize() {
  # prefer terminal safe colored and bold text when tput is supported
  if tput setaf 0 &>/dev/null; then
    ALL_OFF="$(tput sgr0)"
    BOLD="$(tput bold)"
    BLUE="${BOLD}$(tput setaf 4)"
    GREEN="${BOLD}$(tput setaf 2)"
    RED="${BOLD}$(tput setaf 1)"
    YELLOW="${BOLD}$(tput setaf 3)"
  else
    ALL_OFF="\e[0m"
    BOLD="\e[1m"
    BLUE="${BOLD}\e[34m"
    GREEN="${BOLD}\e[32m"
    RED="${BOLD}\e[31m"
    YELLOW="${BOLD}\e[33m"
  fi
  readonly ALL_OFF BOLD BLUE GREEN RED YELLOW
}

colorize

info() {
  (( QUIET )) && return
  local mesg=$1; shift
  printf "${GREEN}[INFO]${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@"
}

warn() {
  local mesg=$1; shift
  printf "${YELLOW}[WARN]${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}

nix_file="./nix/home/share.nix"
parser_expr=".#homeConfigurations.homelab.config.xdg.dataFile.nvim-treesitter-parsers"

drv=$(nix eval "$parser_expr" --json | jq .source -r)
paths=( $(nix derivation show "$drv" | jq -r 'to_entries[0].value.env.paths') )
for p in "${paths[@]}"; do
  info "Verifying $p"

  src=$(nix derivation show "$p" | jq -r 'to_entries[0].value.env.src')
  tarball=$(nix derivation show "$src" | jq -r 'to_entries[0].value.env.urls')
  hash=$(nix derivation show "$src" | jq -r 'to_entries[0].value.env.outputHash')

  newTarball=$(nix-prefetch-url "$tarball" --print-path --type sha256 | tail -n1)
  newHash=$(nix hash file --base16 --type sha256 --sri "$newTarball")

  if [ "$newHash" != "$hash" ]; then
    warn "Hash changed for parser $p"
    sed -i "s|$hash|$newHash|" "$nix_file"
  else
    echo "Parser is up to date"
  fi

  echo
done
