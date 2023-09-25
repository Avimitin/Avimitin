{ pkgs, ... }:

let
  lib = import ../lib.nix { inherit pkgs; };
in
{
  imports = [ ./share.nix ];

  home = {
    username = "sh1marin";
    homeDirectory = "/home/sh1marin";
    stateVersion = "23.05";
  };

  home.packages = with pkgs; [
    grim
    slurp
    nil
  ];

  xdg.configFile = {
    broot = lib.fromDotfile "broot/conf.toml";
    fcitx5Conf = lib.fromDotfile "fcitx5/conf";
    fcitx5Profile = lib.fromDotfile "fcitx5/profile";
    fontconfig = lib.fromDotfile "fontconfig/conf.d";
    hyprland =
      let
        screenshot = pkgs.writeShellScriptBin "grim-shot" ''
          set -e
          file=$(mktemp --tmpdir "screenshot-XXX-$(date +%F-%T).png")
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" -t png $file
          wl-copy < $file
          rm $file
        '';
        finalHyprConf = pkgs.runCommand "hyprland-config" { } ''
          mkdir $out
          substitute ${../../dotfile/hypr/hyprland.conf} $out/hyprland.conf \
            --subst-var-by wallpaperDaemon ${pkgs.wpaperd}/bin/wpaperd \
            --subst-var-by screenshotScript ${screenshot}/bin/grim-shot
        '';
      in
      {
        target = "hypr/hyprland.conf";
        source = "${finalHyprConf}/hyprland.conf";
      };
    "nix/nix.conf".source = lib.substituted { NixSecretKeyFiles = null; } ../../dotfile/nix/nix.conf;
    paru = lib.fromDotfile "paru/paru.conf";
    systemdServices = lib.fromDotfile "systemd/user";
    waybarConf = lib.fromDotfile "waybar/config";
    waybarStyle = lib.fromDotfile "waybar/style.css";
    wezterm = lib.fromDotfile "wezterm/wezterm.lua";
    wpaperd = lib.fromDotfile "wpaperd/wallpaper.toml";
  };
}
