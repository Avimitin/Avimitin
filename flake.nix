{
  description = "Flakes to setup my configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim = {
      url = "github:Avimitin/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      nvim,
      treefmt-nix,
    }@inputs:
    let
      overlays = [
        nvim.overlays.default
        ((import ./nix/overlay.nix) inputs)
      ];
      pkgsIn = system: import nixpkgs { inherit system overlays; };
      mkHMCfgWith =
        system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsIn system;
          inherit modules;
        };
    in
    {
      homeConfigurations = {
        "homelab" = mkHMCfgWith "x86_64-linux" [ ./nix/home/homelab.nix ];
        "office" = mkHMCfgWith "x86_64-linux" [ ./nix/home/thinkbook.nix ];
        "outside" = mkHMCfgWith "x86_64-linux" [
          ./nix/home/thinkbook.nix
          ./nix/home/thinkbook-carry-case.nix
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = pkgsIn system;
        hmPkg = home-manager.packages.${system}.home-manager;
        treefmtEval = treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          settings.verbose = 1;
          programs.nixfmt.enable = true;
        };
      in
      {
        formatter = treefmtEval.config.build.wrapper;
        legacyPackages = pkgs;
        apps.home-manager = flake-utils.lib.mkApp {
          drv = hmPkg;
        };
      }
    );
}
