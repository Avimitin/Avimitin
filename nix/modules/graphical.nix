{
  pkgs,
  lib,
  config,
  ...
}:

let
  utils = import ../myLib.nix { inherit config; };
  ln = utils.fromDotfile;
in
{
  xdg.dataFile = {
    theme = {
      source = "${../../dotfile/fcitx/theme}";
      target = "fcitx5/themes/default";
    };
  };

  xdg.configFile = {
    mpv = {
      source = pkgs.runCommand "canonize-uosc-mpv-output" { } ''
        mkdir -p $out/fonts $out/scripts

        cp -r ${pkgs.mpvScripts.uosc}/share/fonts/* $out/fonts/
        cp -r ${pkgs.mpvScripts.uosc}/share/mpv/scripts/* $out/scripts/
        cp -r ${pkgs.mpvScripts.thumbfast}/share/mpv/scripts/* $out/scripts/
        cp ${../../dotfile/mpv/mpv.conf} $out/mpv.conf
      '';
      target = "mpv";
    };
    #fontconfig = ln "fontconfig/conf.d";
    alacritty = ln "alacritty/alacritty.toml";
    mangohud = ln "MangoHud/MangoHud.conf";
    mimeapps = ln "mimeapps.list";
    "gtk-3.0" = ln "gtk-3.0";
    "gtk-4.0" = ln "gtk-4.0";
    waybar = ln "waybar";
    hyprlock = {
      source = pkgs.replaceVarsWith {
        name = "hyprlock.conf";
        src = ../../dotfile/hypr/hyprlock.conf;

        replacements = {
          backgroundImage = "${config.home.homeDirectory}/Pictures/Wallpapers/hyprlock.jpg";
        };
      };
      target = "hypr/hyprlock.conf";
    };
    niri = ln "niri/config.kdl";
    foot = ln "foot/foot.ini";
    flameshot = ln "flameshot/flameshot.ini";
    fastfetch = ln "fastfetch/config.jsonc";
    swaync = ln "swaync";
    swaync-service = ln "systemd/user/swaync.service";
    vicinae-server = ln "systemd/user/vicinae-server.service";
    vicinae-config = ln "vicinae/settings.json";
    zathurarc = ln "zathura/zathurarc";
    swaybg = ln "systemd/user/swaybg@.service";
    xdgPortal = ln "xdg-desktop-portal";
  };
}
