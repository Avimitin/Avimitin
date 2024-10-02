{ buildGoModule, fetchFromGitHub, cacert }:
buildGoModule {
  name = "qbittorrent-cli";

  src = fetchFromGitHub {
    owner = "ludviglundgren";
    repo = "qbittorrent-cli";
    rev = "4631210bf1a7b3b82398872ea21dbb5108fee9a3";
    hash = "sha256-XcmgTBqr5DTKwX80EMUA41FY9yIztYNHW4kgF5z8TVg=";
  };

  propagatedBuildInputs = [
    cacert
  ];

  vendorHash = "sha256-neAyMux04H3rfHYvCaX0VXSLhCGsVW5DiJYL/rFruJ4=";
}
