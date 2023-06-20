{
  description = "Flakes to setup my configuration";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      allSystems = [ "x86_64-linux" ];

      eachSystems = f:
        nixpkgs.lib.genAttrs allSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
      apps = eachSystems ({ pkgs, ... }:
        let
          my-nix-formatter = (pkgs.writeScriptBin "my-nix-formatter" ''
            find . -name '*.nix' -exec ${pkgs.nixfmt}/bin/nixfmt {} +
          '');
        in {
          fmt = {
            type = "app";
            program = "${my-nix-formatter}/bin/my-nix-formatter";
          };
        });
    };
}
