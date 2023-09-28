{ pkgs, lib, config, ... }:
{
  xdg.configFile = {
    hyprland =
      let
        hypr-extra-conf = pkgs.callPackage ../../dotfile/hypr/carried-out.nix { inherit (config.home) homeDirectory; };
        hypr-conf = pkgs.callPackage ../../dotfile/hypr { inherit hypr-extra-conf; };
      in
      lib.mkForce {
        target = "hypr/hyprland.conf";
        source = "${hypr-conf}/hyprland.conf";
      };
  };
}
