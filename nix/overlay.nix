inputs:

final: prev: {
  my-nvim-src = inputs.nvim.outPath;
  qbittorrent-cli = final.callPackage ./pkgs/qbittorrent-cli.nix { };
  delta = prev.delta.overrideAttrs (old: rec {
    src = final.fetchFromGitHub {
      owner = "dandavison";
      repo = old.pname;
      rev = "a01141b72001f4c630d77cf5274267d7638851e4";
      hash = "sha256-My51pQw5a2Y2VTu39MmnjGfmCavg8pFqOmOntUildS0=";
    };
    cargoDeps = old.cargoDeps.overrideAttrs (final.lib.const {
      name = old.cargoDeps.name;
      inherit src;
      outputHash = "sha256-TJ/yLt53hKElylycUfGV8JGt7GzqSnIO3ImhZvhVQu0=";
    });
  });
}
