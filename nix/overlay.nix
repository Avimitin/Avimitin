inputs:

final: prev: {
  my-neovim = inputs.nvim.packages.${final.stdenv.hostPlatform.system}.neovim;

  qbittorrent-cli = final.callPackage ./pkgs/qbittorrent-cli.nix { };
  mkAppleFonts = final.callPackage ./pkgs/apple-fonts.nix { };
  # sans-serif
  apple-sf-pro = final.mkAppleFonts {
    fontName = "SF-Pro";
    hash = "sha256-u7cLbIRELSNFUa2OW/ZAgIu6vbmK/8kXXqU97xphA+0=";
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
  cascadia-next-sc = final.fetchurl {
    url = "https://github.com/microsoft/cascadia-code/releases/download/cascadia-next/CascadiaNextSC.wght.ttf";
    hash = "sha256-Dy1DJF+vjJ6kyU2qLL0HhT4xCONH6W/UTjfWrqqKfu8=";
  };
}
