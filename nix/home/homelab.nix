{
  pkgs,
  lib,
  config,
  ...
}:

let
  utils = import ../lib.nix { inherit pkgs config; };
  ln = utils.fromDotfile;
in
{
  imports = [ ./share.nix ];

  home = {
    username = "sh1marin";
    homeDirectory = "/home/sh1marin";
    stateVersion = "24.11";
  };

  xdg.dataFile = {
    theme = {
      source = "${../../dotfile/fcitx/theme}";
      target = "fcitx5/themes/default";
    };
    sfMono = {
      source = "${pkgs.apple-sf-mono}/share/fonts/opentype";
      target = "fonts/opentype/AppleSFMonoFonts";
    };
    sfPro = {
      source = "${pkgs.apple-sf-pro}/share/fonts/opentype";
      target = "fonts/opentype/AppleSFProFonts";
    };
    NY = {
      source = "${pkgs.apple-new-york}/share/fonts/opentype";
      target = "fonts/opentype/AppleNYFonts";
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
    fontconfig = ln "fontconfig/conf.d";
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
    ghostty = ln "ghostty/config";
    flameshot = ln "flameshot/flameshot.ini";
    fastfetch = ln "fastfetch/config.jsonc";
    swaync = ln "swaync";
    swaync-service = ln "systemd/user/swaync.service";
    vicinae-server = ln "systemd/user/vicinae-server.service";
    zathurarc = ln "zathura/zathurarc";
  };

  # Use system fc-cache here
  home.activation.forceUpdateFontConfigCache = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    verboseEcho "Rebuilding font cache"
    run /usr/bin/fc-cache -f
  '';
}
