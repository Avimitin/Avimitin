# https://github.com/VergeDX/nur-packages/blob/master/pkgs/apple-fonts/common.nix

{ stdenv
, fetchurl
, p7zip
}:

{ fontName ? ""
, hash ? ""
}:
stdenv.mkDerivation {
  name = "Apple-${fontName}";

  src = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/${fontName}.dmg";
    inherit hash;
  };

  nativeBuildInputs = [ p7zip ];
  unpackPhase = ''
    7z x $src
  '';

  buildPhase = ''
    cd "$( echo ${fontName} | sed 's/-//' )Fonts"
    pkg=$(find . -name '*.pkg')
    7z x "$pkg"
    7z x 'Payload~'
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/
    cp -v Library/Fonts/* $out/share/fonts/opentype/
  '';
}
