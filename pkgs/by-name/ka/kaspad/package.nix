{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "kaspad";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kaspanet";
    repo = "rusty-kaspa";
    rev = "v${version}";
    hash = "sha256-KVc3IcgCGwhdfHZ33nnuoc/TbCR+Clva+3CYQFHsLcc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/1dEWqB6F93I7W3pvGlksDNZCYI4u0+ZmgofeeNHfwM=";

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];

  # Set environment variables for build
  env = {
    PROTOC = "${protobuf}/bin/protoc";
    OPENSSL_NO_VENDOR = "1";
  };

  # Build only the kaspad binary
  cargoBuildFlags = [
    "--bin=kaspad"
  ];

  # Enable optimizations for production build
  buildType = "release";

  # Network tests require external connections
  doCheck = false;

  meta = {
    description = "Kaspa full-node daemon implementation in Rust";
    longDescription = ''
      Kaspad is a full node implementation of the Kaspa cryptocurrency protocol.
      It implements a high-throughput, scalable, and secure blockchain infrastructure
      using a blockDAG (directed acyclic graph) instead of a traditional blockchain.
    '';
    homepage = "https://github.com/kaspanet/rusty-kaspa";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [codevryn];
    platforms = lib.platforms.unix;
    mainProgram = "kaspad";
  };
}
