inputs:

final: prev: {
  my-nvim-src = inputs.nvim.outPath;
  qbittorrent-cli = final.callPackage ./pkgs/qbittorrent-cli.nix { };
}
