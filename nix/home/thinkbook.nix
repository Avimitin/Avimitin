{ pkgs, config, ... }:

let
  lib = import ../lib.nix { inherit pkgs; };
in
rec {
  imports = [ ./share.nix ];

  home = {
    username = "sh1marin";
    homeDirectory = "/home/sh1marin";
    stateVersion = "23.05";
  };

  home.packages = with pkgs; [
    grim
    slurp
  ];

  xdg.configFile = {
    dunst = lib.fromDotfile "dunst/dunstrc";
    rofi = lib.fromDotfile "rofi";
    broot = lib.fromDotfile "broot/conf.toml";
    fcitx5Conf = lib.fromDotfile "fcitx5/conf";
    fcitx5Profile = lib.fromDotfile "fcitx5/profile";
    fcitx5Config = lib.fromDotfile "fcitx5/config";
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
        path = "${home.homeDirectory}/Pictures/Anime";
        duration = "30m";
      };
    };
  };
}
