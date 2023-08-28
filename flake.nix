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
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        apps.hm-switch = flake-utils.lib.mkApp {
          drv = with builtins; pkgs.writeShellScriptBin "HomeManagerSwitcher" ''
            home=$1; shift
            [[ "x$home" = "x" ]] \
              && echo -e "Error: No home config given.\n\nAvailable: ${concatStringsSep ", " (attrNames self.homeConfigurations)}" \
              && exit 1
            nix run home-manager/master -- switch --flake ".?submodules=1#$home"
          '';
        };
      });
}
