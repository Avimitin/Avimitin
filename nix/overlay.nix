final: prev: {
  neovim-nightly-bin = final.neovim-unwrapped.overrideAttrs {
    version = "nightly-v0.10.0-dev-2110+g2fce95ec4";
    src = final.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "2fce95ec439a1121271798cf00fc8ec9878813fa";
      hash = "sha256-sEDuzyFwed937nnjyt/LfShaCx2jcFJ8Rp19+dgjroo=";
    };
  };
  neovim = final.wrapNeovim final.neovim-nightly-bin { };
}
