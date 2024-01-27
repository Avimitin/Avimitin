#!/bin/sh

set -e

nix_file="./nix/home/share.nix"
parser_expr=".#homeConfigurations.homelab.config.xdg.dataFile.nvim-treesitter-parsers"

drv=$(nix eval "$parser_expr" --json | jq .source -r)
paths=( $(nix derivation show "$drv" | jq -r 'to_entries[0].value.env.paths') )
for p in "${paths[@]}"; do
  echo "[INFO] Verifying $p"

  src=$(nix derivation show "$p" | jq -r 'to_entries[0].value.env.src')
  tarball=$(nix derivation show "$src" | jq -r 'to_entries[0].value.env.urls')
  hash=$(nix derivation show "$src" | jq -r 'to_entries[0].value.env.outputHash')

  newTarball=$(nix-prefetch-url "$tarball" --print-path --type sha256 | tail -n1)
  newHash=$(nix hash file --base16 --type sha256 --sri "$newTarball")

  if [ "$newHash" != "$hash" ]; then
    echo "[WARN] Hash changed for parser $p"
    sed -i "s|$hash|$newHash|" "$nix_file"
  else
    echo "[INFO] Parser $p is up to date"
  fi
done
