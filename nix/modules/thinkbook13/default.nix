{ ... }:
let
  userInfo = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.sh1marin = {
      news.display = "silent";

      home = {
        username = "sh1marin";
        homeDirectory = "/home/sh1marin";
        stateVersion = "25.11";
      };

      imports = [
        ../graphical.nix
        ../coding.nix
      ];
    };
  };
in
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    userInfo
  ];
}
