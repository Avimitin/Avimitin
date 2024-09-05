inputs:

final: prev: {
  my-nvim-src = inputs.nvim.outPath;
  qbittorrent-cli = final.callPackage ./pkgs/qbittorrent-cli.nix { };
  mkAppleFonts = final.callPackage ./pkgs/apple-fonts.nix { };
  apple-sf-mono = final.mkAppleFonts {
    fontName = "SF-Mono";
    hash = "sha256-Uarx1TKO7g5yVBXAx6Yki065rz/wRuYiHPzzi6cTTl8=";
  };
}
