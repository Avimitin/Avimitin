{ lib
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, withSlang ? true
}:

rustPlatform.buildRustPackage (rec {
  pname = "veridian";
  version = "2024-05-27";

  src = fetchFromGitHub {
    owner = "Avimitin";
    repo = pname;
    rev = "cebe5c67892dafadd0657e8e551c97abe7b3924f";
    hash = "sha256-bvJL9T0hcfVVSaJdlxwo35dQOQVqKPCk5RwMoRqiopU=";
  };

  cargoHash = "sha256-He9jLRNYLQ3rhbdmVdcfCax1qTTZ5lJ6R1u4W6+N4tc=";

  doCheck = false;

  meta = with lib; {
    description = "A SystemVerilog language server";
    homepage = "https://github.com/vivekmalneedi/veridian";
    license = licenses.mit;
    maintainers = [ ];
  };
} // (lib.optionalAttrs withSlang {
  patches = [ ./0001-Allow-building-with-slang-when-off-line.patch ];
  SLANG_DIR = builtins.fetchTarball {
    name = "slang-linux-0.7";
    url = "https://github.com/MikePopoloski/slang/releases/download/v0.7/slang-linux.tar.gz";
    sha256 = "sha256:1mib4n73whlj7dvp6gxlq89v3cq3g9jrhhz9s5488g9gzw4x21bk";
  };
  buildFeatures = [ "slang" ];
  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ openssl ];
}))
