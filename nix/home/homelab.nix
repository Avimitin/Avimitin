{
  pkgs,
  lib,
  config,
  ...
}:

let
  utils = import ../lib.nix { inherit pkgs config; };
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
    fontconfig = utils.fromDotfile "fontconfig/conf.d";
    alacritty = utils.fromDotfile "alacritty/alacritty.toml";
    mangohud = utils.fromDotfile "MangoHud/MangoHud.conf";
    mimeapps = utils.fromDotfile "mimeapps.list";
    "gtk-3.0" = utils.fromDotfile "gtk-3.0";
    "gtk-4.0" = utils.fromDotfile "gtk-4.0";
    waybar = utils.fromDotfile "waybar";
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
    niri = utils.fromDotfile "niri/config.kdl";
    foot = utils.fromDotfile "foot/foot.ini";
    ghostty = utils.fromDotfile "ghostty/config";
    flameshot = utils.fromDotfile "flameshot/flameshot.ini";
    fastfetch = utils.fromDotfile "fastfetch/config.jsonc";
    swaync = utils.fromDotfile "swaync";
    swaync-service = utils.fromDotfile "systemd/user/swaync.service";
  };

  # Use system fc-cache here
  home.activation.forceUpdateFontConfigCache = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    verboseEcho "Rebuilding font cache"
    run /usr/bin/fc-cache -f
  '';
}
