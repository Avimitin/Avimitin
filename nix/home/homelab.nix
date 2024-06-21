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
        mkdir $out
        cp -r ${pkgs.mpvScripts.uosc}/share/fonts $out/
        cp -r ${pkgs.mpvScripts.uosc}/share/mpv/scripts $out/
      '';
      target = "mpv";
    };
    dunst = lib.fromDotfile "dunst/dunstrc";
    rofi = lib.fromDotfile "rofi";
    broot = lib.fromDotfile "broot/conf.toml";
    fontconfig = lib.fromDotfile "fontconfig/conf.d";
    hyprland = {
      target = "hypr/hyprland.conf";
      source =
        let
          hypr-conf = pkgs.callPackage ../../dotfile/hypr { };
        in
        "${hypr-conf}/hyprland.conf";
    };
    paru = lib.fromDotfile "paru/paru.conf";
    waybarConf = lib.fromDotfile "waybar/config";
    waybarStyle = lib.fromDotfile "waybar/style.css";
    wezterm = lib.fromDotfile "wezterm/wezterm.lua";
    kitty = lib.fromDotfile "kitty/kitty.conf";
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
