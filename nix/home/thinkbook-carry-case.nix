{ pkgs, lib, config, ... }:
{
  xdg.configFile = {
    hyprland =
      let
        hypr-conf = pkgs.callPackage ../../dotfile/hypr { isCarryOut = true; };
      in
      lib.mkForce {
        target = "hypr/hyprland.conf";
        source = "${hypr-conf}/hyprland.conf";
      };
  };

  programs.wpaperd.settings = lib.mkForce {
    default = {
      # Use SFW picture as wallpaper when carry out
      path = "${config.home.homeDirectory}/Pictures/Wallpapers/4K";
      duration = "30m";
      apply-shadow = true;
    };
  };
}
