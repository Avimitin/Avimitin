final: prev: {
  neovim-nightly-bin = final.neovim-unwrapped.overrideAttrs {
    version = "nightly";
    src = final.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "nightly";
      hash = "sha256-dUv+Zgz+6lRodkhp4yOhyvKNBdvLDTbQNJj49mDwy7o=";
    };
  };
  neovim = final.wrapNeovim final.neovim-nightly-bin { };
}
