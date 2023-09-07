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

  xdg.configFile = {
    broot = lib.fromDotfile "broot/conf.toml";
    fcitx5Conf = lib.fromDotfile "fcitx5/conf";
    fcitx5Profile = lib.fromDotfile "fcitx5/profile";
    fontconfig = lib.fromDotfile "fontconfig/conf.d";
    hyprland =
      let
        wpaperd = pkgs.rustPlatform.buildRustPackage rec {
          pname = "wpaperd";
          version = "unstable-07-19";
          src = pkgs.fetchFromGitHub {
            repo = pname;
            owner = "danyspin97";
            rev = "3d45adf8d1b4f3b6c910df371a0183d80f6509d9";
            sha256 = "sha256-2bAwitXmoz9tC/7BJGqdrA2qq3Bz7j2RkjdwAkMnScc=";
          };
          cargoHash = "sha256-NaQmUEMRBMkrmAiY50i0J3ZZNh6PcH2H4fw1UeWaphU=";
        };
        screenshot = pkgs.writeShellScriptBin "grim" ''
          set -e
          file=$(mktemp "screenshot-XXX-$(date +%F-%T).png")
          grim -g "$(slurp)" -t png $file
          wl-copy < $file
          rm $file
        '';
        finalHyprConf = pkgs.runCommand "hyprland-config" { } ''
          mkdir $out
          substitute ${../../dotfile/hypr/hyprland.conf} $out/hyprland.conf \
            --subst-var-by wallpaperDaemon ${wpaperd}/bin/wpaperd \
            --subst-var-by screenshotScript ${screenshot}/bin/grim
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
