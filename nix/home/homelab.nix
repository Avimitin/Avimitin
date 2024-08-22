{ pkgs, config, ... }:

let
  lib = import ../lib.nix { inherit pkgs; };
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
      source = "${../../fcitx/theme}";
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
    dunst = lib.fromDotfile "dunst/dunstrc";
    rofi = lib.fromDotfile "rofi";
    broot = lib.fromDotfile "broot/conf.toml";
    fontconfig = lib.fromDotfile "fontconfig/conf.d";
    hyprland = {
      target = "hypr";
      source = toString (pkgs.callPackage ../../dotfile/hypr { inherit (home) homeDirectory; });
    };
    paru = lib.fromDotfile "paru/paru.conf";
    waybarConf = lib.fromDotfile "waybar/config";
    waybarStyle = lib.fromDotfile "waybar/style.css";
    wezterm = lib.fromDotfile "wezterm/wezterm.lua";
    alacritty = lib.fromDotfile "alacritty/alacritty.toml";
    mangohud = lib.fromDotfile "MangoHud/MangoHud.conf";
    mimeapps = lib.fromDotfile "mimeapps.list";
    sioyek = lib.fromDotfile "sioyek";
  };

  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "${home.homeDirectory}/Pictures/Wallpapers";
        duration = "30m";
      };
    };
  };
}
