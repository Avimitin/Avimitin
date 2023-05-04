set commit "dc543b2a658837b9447daec30258e44643571bb9"
set sha256sum "a5c19483ec411779dfca6de13208fe41def4befc8bf2abc80b010f6b23fa4381"
set source \
  "https://raw.githubusercontent.com/jorgebucaran/fisher/$commit/functions/fisher.fish"

set script_file (mktemp -t 'fisher_XXX.fish')
curl -sSfLo $script_file $source

echo "$sha256sum  $script_file" \
  | sha256sum --check
  or exit 1

fish --no-config --command \
  "source $script_file && fisher install jorgebucaran/fisher"

set ensure_install \
  "patrickf1/fzf.fish" \
  "jorgebucaran/autopair.fish" \
  "jorgebucaran/hydro"

fish --command \
  "fisher install $ensure_install"
