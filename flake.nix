{
  description = "Flakes to setup my configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        formatter = (pkgs.writeScriptBin "my-nix-formatter" ''
          find . -name '*.nix' -exec ${pkgs.nixfmt}/bin/nixfmt {} +
        '');
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
      });
}
