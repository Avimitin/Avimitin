inputs:

final: prev: {
  my-nvim-src = inputs.nvim.outPath;
  qbittorrent-cli = final.callPackage ./pkgs/qbittorrent-cli.nix { };
  mkAppleFonts = final.callPackage ./pkgs/apple-fonts.nix { };
  # sans-serif
  apple-sf-pro = final.mkAppleFonts {
    fontName = "SF-Pro";
    hash = "sha256-B8xljBAqOoRFXvSOkOKDDWeYUebtMmQLJ8lF05iFnXk=";
  };
  # monospace
  apple-sf-mono = final.mkAppleFonts {
    fontName = "SF-Mono";
    hash = "sha256-Uarx1TKO7g5yVBXAx6Yki065rz/wRuYiHPzzi6cTTl8=";
  };
  # serif
  apple-new-york = final.mkAppleFonts {
    fontName = "NY";
    hash = "sha256-yYyqkox2x9nQ842laXCqA3UwOpUGyIfUuprX975OsLA=";
  };
}
