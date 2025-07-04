{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "kaspa-cli";
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

  # Build only the kaspa-cli binary
  cargoBuildFlags = [
    "--bin=kaspa-cli"
  ];

  # Enable optimizations for production build
  buildType = "release";

  # Network tests require external connections
  doCheck = false;

  meta = {
    description = "Command-line wallet for the Kaspa cryptocurrency";
    longDescription = ''
      kaspa-cli provides a cli-driven RPC interface to the node and
      a terminal interface to the Rusty Kaspa Wallet runtime.
    '';
    homepage = "https://github.com/kaspanet/rusty-kaspa";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [codevryn];
    platforms = lib.platforms.unix;
    mainProgram = "kaspa-cli";
  };
}
