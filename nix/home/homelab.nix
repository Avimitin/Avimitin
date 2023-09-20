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

  xdg.configFile = {
    systemdServices = lib.fromDotfile "systemd/user";
    paru = lib.fromDotfile "paru/paru.conf";

    # This server will serve as a nix store server
    "nix/nix.conf".source = lib.substituted { NixSecretKeyFiles = "${home.homeDirectory}/.config/nix/nix-cache-sk"; } ../../dotfile/nix/nix.conf;
  };
}
