inputs:

final: prev: {
  my-nvim-src = inputs.nvim.outPath;
  qbittorrent-cli = final.callPackage ./pkgs/qbittorrent-cli.nix { };
  mkAppleFonts = final.callPackage ./pkgs/apple-fonts.nix { };
  # sans-serif
  apple-sf-pro = final.mkAppleFonts {
    fontName = "SF-Pro";
    hash = "sha256-IccB0uWWfPCidHYX6sAusuEZX906dVYo8IaqeX7/O88=";
  };
  # monospace
  apple-sf-mono = final.mkAppleFonts {
    fontName = "SF-Mono";
    hash = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
  };
  # serif
  apple-new-york = final.mkAppleFonts {
    fontName = "NY";
    hash = "sha256-HC7ttFJswPMm+Lfql49aQzdWR2osjFYHJTdgjtuI+PQ=";
  };
}
