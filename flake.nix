{
  description = "Flakes to setup my configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim.url = "github:Avimitin/nvim";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      nvim,
      treefmt-nix,
    }@inputs:
    let
      overlays = [
        nvim.overlays.default
        ((import ./nix/overlay.nix) inputs)
      ];
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        systems = [
          "x86_64-linux"
        ];

        imports = [
          inputs.treefmt-nix.flakeModule
        ];

        flake = {
          homeConfigurations = {
            "homelab" = home-manager.lib.homeManagerConfiguration (
              withSystem "x86_64-linux" (
                { pkgs, ... }:
                {
                  inherit pkgs;
                  modules = [
                    ./nix/home/homelab.nix
                  ];
                }
              )
            );
          };
        };

        perSystem =
          { system, inputs', ... }:
          let
            pkgs = import nixpkgs {
              inherit system overlays;
              config.allowUnfreePredicate =
                pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                  "claude-code"
                ];
            };
          in
          {
            # Override the default "pkgs" attribute in per-system config.
            _module.args.pkgs = pkgs;

            # Although the pkgs attribute is already override, but I am afraid
            # that the magical evaluation of "pkgs" is confusing, and will lead
            # to debug hell. So here we use the "pkgs" in "let-in binding" to
            # explicitly told every user we are using an overlayed version of
            # nixpkgs.
            legacyPackages = pkgs;

            apps.home-manager = {
              type = "app";
              program = inputs'.home-manager.packages.home-manager;
            };
            treefmt = {
              projectRootFile = "flake.nix";
              settings.on-unmatched = "debug";
              programs = {
                nixfmt.enable = true;
              };
            };
          };
      }
    );
}
