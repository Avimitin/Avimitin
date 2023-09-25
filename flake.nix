{
  description = "Flakes to setup my configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }:
    let
      pkgsIn = system: import nixpkgs { inherit system; };
      mkHMCfgWith = system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsIn system;
          inherit modules;
        };
    in
    {
      templates = import ./nix/templates;
      homeConfigurations = {
        "homelab" = mkHMCfgWith "x86_64-linux" [ ./nix/home/homelab.nix ];
        "thinkbook" = mkHMCfgWith "x86_64-linux" [ ./nix/home/thinkbook.nix ];
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = pkgsIn system;
        hmPkg = home-manager.packages.${system}.home-manager;
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        apps.home-manager = flake-utils.lib.mkApp {
          drv = hmPkg;
        };
      });
}
