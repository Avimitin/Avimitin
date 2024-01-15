final: prev: {
  neovim-nightly-bin = final.neovim-unwrapped.overrideAttrs {
    version = "nightly";
    src = final.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "nightly";
      hash = "sha256-1g9PtEgfZzFdNJTFkok0o6J4Mr0ZlLwxR6bcHlNwAtU=";
    };
  };
  neovim = final.wrapNeovim final.neovim-nightly-bin { };
}
