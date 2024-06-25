{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  name = "qbittorrent-cli";

  src = fetchFromGitHub {
    owner = "ludviglundgren";
    repo = "qbittorrent-cli";
    rev = "d029c02699408d2ee4f13cee841eb9ea5cc7b2b3";
    hash = "sha256-RxObIyEeT0UdJO1DhCc4ZITTwtopn6Vwgz01keQzLGI=";
  };

  vendorHash = "sha256-PFI5pcwLdE/OBElwV8tm/ganH3/PI6/mCSKn6MKvIgg=";
}
