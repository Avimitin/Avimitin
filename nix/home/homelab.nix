{ pkgs, lib, config, ... }:

let
  utils = import ../lib.nix { inherit pkgs; };
in
rec {
  imports = [ ./share.nix ];

  home = {
    username = "sh1marin";
    homeDirectory = "/home/sh1marin";
    stateVersion = "24.11";
  };

  home.packages = with pkgs; [
    qbittorrent-cli
    grim
    slurp
  ];

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
    cascadiaNextSC = {
      source = "${pkgs.cascadia-next-sc}";
      target = "fonts/opentype/CascadiaNextSC.wght.ttf";
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
    dunst = utils.fromDotfile "dunst/dunstrc";
    rofi = utils.fromDotfile "rofi";
    broot = utils.fromDotfile "broot/conf.toml";
    fontconfig = utils.fromDotfile "fontconfig/conf.d";
    paru = utils.fromDotfile "paru/paru.conf";
    wezterm = utils.fromDotfile "wezterm/wezterm.lua";
    alacritty = utils.fromDotfile "alacritty/alacritty.toml";
    mangohud = utils.fromDotfile "MangoHud/MangoHud.conf";
    neovide = utils.fromDotfile "neovide";
    mimeapps = utils.fromDotfile "mimeapps.list";
    sioyek = utils.fromDotfile "sioyek";
    "gtk-3.0" = utils.fromDotfile "gtk-3.0";
  };

  # Use system fc-cache here
  home.activation.forceUpdateFontConfigCache = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    verboseEcho "Rebuilding font cache"
    run /usr/bin/fc-cache -f
  '';
}
