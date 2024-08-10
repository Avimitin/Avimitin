{ runCommand, writeShellScriptBin, writeShellApplication, jq, grim, slurp, callPackage, isCarryOut ? false }:
let
  screenshotScript = writeShellApplication {
    name = "wayland-screenshoter";

    runtimeInputs = [
      jq
      grim
      slurp
    ];

    text = ''
      set -e

      # Step1: take the whole screen
      _ACTIVE_SCREEN=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
      _SCREEN_CAPTURE="$(mktemp -t "screenshot-$_ACTIVE_SCREEN-XXX.png")"
      grim -o "$_ACTIVE_SCREEN" "$_SCREEN_CAPTURE"

      # Step2: show the image fullscreen and enable selection
      hyprctl -q --batch "\
          keyword windowrulev2 noanim,class:(swayimg);\
          keyword windowrulev2 noborder,class:(swayimg);\
          keyword windowrulev2 noshadow,class:(swayimg)"
      swayimg --config=info.show=no --fullscreen "$_SCREEN_CAPTURE" &
      _pid="$!"

      on_exit() {
        # stop swayimg
        kill "$_pid" || true
        # clean up
        rm -f "$_SCREEN_CAPTURE"
        # reload hypr animation & shadow
        hyprctl -q keyword windowrulev2 'unset,class:(swayimg)'
      }
      trap on_exit EXIT

      _OUT_DIR="$HOME/Pictures/Screenshot"
      _OUT_FILE="$_OUT_DIR/screenshot-$(date +%F-%T).png"
      mkdir -p "$_OUT_DIR"

      sleep 0.3
      _GEO="$(slurp 2>&1)"
      if [ "$_GEO" == "selection cancelled" ]; then
        exit 0
      fi

      if ! grim -g "$_GEO" -t png "$_OUT_FILE"; then
        exit 1
      fi
      if [ ! -r "$_OUT_FILE" ]; then
        exit 1
      fi

      wl-copy < "$_OUT_FILE"

      if [[ -z "''${DELETE_SCREENSHOT:-}" ]]; then
        notify-send "Screenshot saved under $_OUT_DIR"
      else
        rm -f "$_OUT_FILE"
      fi
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
