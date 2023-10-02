{ runCommand, writeShellScriptBin, wpaperd, grim, slurp, callPackage, isCarryOut ? false }:
let
  screenshot = writeShellScriptBin "grim-shot" ''
    set -e
    file=$(mktemp --tmpdir "screenshot-XXX-$(date +%F-%T).png")
    ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" -t png $file
    wl-copy < $file
    rm $file
  '';
  extraConf = callPackage (if isCarryOut then ./carried-out.nix else ./office.nix) { };
in
runCommand "hyprland-conf-generator" { } ''
  mkdir $out

  substitute ${../../dotfile/hypr/hyprland.conf} $out/hyprland.conf \
    --subst-var-by screenshotScript ${screenshot}/bin/grim-shot \
    --subst-var-by extraConf ${extraConf}
''
