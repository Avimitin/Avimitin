final: prev:
let
  latestWpaperd = final.rustPlatform.buildRustPackage rec {
    pname = "wpaperd";
    version = "0.3.0+rev=3d45adf8";

    src = final.fetchFromGitHub {
      owner = "danyspin97";
      repo = pname;
      rev = "3d45adf8d1b4f3b6c910df371a0183d80f6509d9";
      sha256 = "sha256-2bAwitXmoz9tC/7BJGqdrA2qq3Bz7j2RkjdwAkMnScc=";
    };

    nativeBuildInputs = [
      final.pkg-config
    ];
    buildInputs = [
      final.libxkbcommon
    ];

    cargoHash = "sha256-Om7URC2X6E0mpvJPuEKRyAmgQjz0YJdaPodF8o8GTDY=";
  };
in
{
  mkWpaperDWrapper = config:
    final.writeScript "wpaperd-wrapper" ''
      log=$(mktemp -t "wpaperd-$(date +%F-%T)-XXX")
      ${latestWpaperd}/bin/wpaperd -w ${config} &> $log
    '';
}
