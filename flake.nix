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
      applyHomeConfig = home-manager.lib.homeManagerConfiguration;
    in
    {
      templates = import ./nix/templates;
      homeConfigurations = {
        "homelab" = applyHomeConfig {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./nix/home/homelab.nix ];
        };
        "thinkbook" = applyHomeConfig {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./nix/home/thinkbook.nix ];
        };
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        apps.hm-switch = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "HomeManagerSwitcher" ''
            home=$1; shift
            [[ "x$home" = "x" ]] && echo "No home config given" && exit 1
            nix run home-manager/master -- switch --flake ".?submodules=1#$home"
          '';
        };
      });
}
