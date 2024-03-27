{ runCommand, writeShellScriptBin, writeShellApplication, grim, slurp, callPackage, isCarryOut ? false }:
let
  screenshotScript = writeShellApplication {
    name = "wayland-screenshoter";

    runtimeInputs = [
      grim
      slurp
    ];

    text = ''
      file=$(mktemp -t "screenshot-XXX-$(date +%F-%T).png")
      grim -g "$(slurp)" -t png "$file"
      wl-copy < "$file"
      [[ -n "''${DELETE_SCREENSHOT:-}" ]] && rm "$file"
    '';
  };
  screenctl = writeShellScriptBin "hyprland-all-screen-ctl" ''
    action=$1; shift
    [[ "$action" = "" ]] && echo "No arguments" && exit 1

    screens=( $(hyprctl monitors -j | jq -r .[].name) )

    for sc in ''${screens[@]}; do
      echo "Screen $sc $action"
      hyprctl dispatch dpms $action $sc
    done

    echo "All done"
  '';
  screenlock = writeShellScriptBin "swaylock-with-random-pic" ''
    systemd-run --user --collect --unit=swayidle \
      swayidle -w \
        timeout 30 'echo "Seems idle, close screens"' \
        timeout 31 '${screenctl}/bin/hyprland-all-screen-ctl off' \
          resume '${screenctl}/bin/hyprland-all-screen-ctl on'
    swaylock --ignore-empty-password \
      --show-failed-attempts \
      --image $(find ~/Pictures/Wallpapers -type f | shuf -n1) \
      --show-keyboard-layout \
      --indicator-caps-lock
    systemctl --user stop swayidle
  '';
  extraConf = callPackage (if isCarryOut then ./carried-out.nix else ./office.nix) { };
in
runCommand "hyprland-conf-generator" { } ''
  mkdir $out

  substitute ${../../dotfile/hypr/hyprland.conf} $out/hyprland.conf \
    --subst-var-by screenshotScript ${screenshotScript}/bin/wayland-screenshoter \
    --subst-var-by screenlockScript ${screenlock}/bin/swaylock-with-random-pic \
    --subst-var-by extraConf ${extraConf}
''
