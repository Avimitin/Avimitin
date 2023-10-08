{ pkgs, ... }:

let
  lib = import ../lib.nix { inherit pkgs; };
in
rec {
  imports = [ ./share.nix ];

  home = {
    username = "i";
    homeDirectory = "/home/i";
    stateVersion = "23.05";
  };

  home.packages = with pkgs; [
    metals
    nil
  ];

  # This machine also serve as a build cache
  nix.settings.extra-secret-key-files = "${home.homeDirectory}/.config/nix/nix-cache-sk";

  xdg.configFile = {
    paru = lib.fromDotfile "paru/paru.conf";
  };
}
