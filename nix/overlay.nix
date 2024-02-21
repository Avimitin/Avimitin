final: prev: {
  neovim-nightly-bin =
    let
      srcInfo = final.callPackage ./home/_sources/generated.nix { };
    in
    final.neovim-unwrapped.overrideAttrs {
      inherit (srcInfo.neovim-nightly) version src;
    };
  neovim = final.wrapNeovim final.neovim-nightly-bin { };
}
