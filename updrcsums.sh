#!/bin/bash

sources=(
  ".vimrc"
  ".bashrc"
  "tmux/.tmux.conf.min"
)
output="rcsums.txt"

# Update the sums file
if [[ -e "$output" ]]; then
  rm "$output"
  touch "$output"
fi

for src in ${sources[@]}; do
  sha256sum "$src" >> "$output"
done

echo "Sums store in $output"
