{
  description = "Flakes to setup my configuration";

  inputs = {
    # Unstable nixpkgs for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # "stable" nixpkgs for system usage
    nixpkgs-channel.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-25.11/nixexprs.tar.xz";
    # Modulerize nix modules
    flake-parts.url = "github:hercules-ci/flake-parts";
    # User home configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # My neovim bundle
    nvim.url = "github:Avimitin/nvim";
    # Nix formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nix Devops for machine nix configuration deployment
    colmena.url = "github:zhaofengli/colmena";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      treefmt-nix,
      ...
    }@inputs:
    let
      overlays = [
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

        # colmenaHive is the central collection of all the NixOS configuration
        flake.colmenaHive = inputs.colmena.lib.makeHive {
          meta.nixpkgs.lib = inputs.nixpkgs.lib;

          # I would like to configure Nixpkgs per machine based
          meta.nodeNixpkgs = {
            thinkbook13 = import inputs.nixpkgs-channel {
              system = "x86_64-linux";
              overlays = [];
            };
          };

          thinkbook13 = {
            deployment = {
              # Allow local deployment with `colmena apply-local`
              allowLocalDeployment = true;

              # Disable SSH deployment. This node will be skipped in a
              # normal`colmena apply`.
              targetHost = null;
            };

            imports = [
              inputs.home-manager.nixosModules.home-manager
              # Gives modules ability to access flake input
              { home-manager.extraSpecialArgs = { flake-inputs = inputs; }; }
              ./nix/modules/thinkbook13
            ];
          };
        };

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
            # This work as same as `specialArgs`
            _module.args.pkgs = pkgs;

            # Although the pkgs attribute is already override, but I am afraid
            # that the magical evaluation of "pkgs" is confusing, and will lead
            # to debug hell. So here we use the "pkgs" in "let-in binding" to
            # explicitly told every user we are using an overlayed version of
            # nixpkgs.
            legacyPackages = pkgs;

            packages.colmena = inputs'.colmena.packages.colmena;

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
