{
  description = "Flakes to setup my configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        templates = {
          "rust" = {
            path = ./nix/template/rust;
            description = "My basic rust project setup";
          };
          "generic" = {
            path = ./nix/template/generic;
            description = "Generic project setup";
          };
        };
        formatter = pkgs.nixpkgs-fmt;
        apps.init-hm = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "init-home-manager" ''
            set -e
            name=$1; shift
            [[ "$name" = "" ]] \
              && echo "No file given" && exit 1
            file="$PWD/nix/home/$name.nix"
            [[ -f "$file" ]] \
              || (echo "$file not found" && exit 1)
            configDir=''${XDG_CONFIG_HOME:-$HOME/.config}
            mkdir -p $configDir/home-manager
            ln -s $file $configDir/home-manager/home.nix
          '';
        };
      });
}
