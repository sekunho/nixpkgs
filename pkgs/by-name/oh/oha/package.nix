{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = "oha";
    tag = "v${version}";
    hash = "sha256-hE3G8hPFHLd+lORzIgdaZ0xxfska011GdVk20bg3S7s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-seipBF9gfut+Z4CKMSbo6/TckSjH8PwF9HbnpbnpL0Q=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    rust-jemalloc-sys
  ];

  # tests don't work inside the sandbox
  doCheck = false;

  meta = {
    description = "HTTP load generator inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    changelog = "https://github.com/hatoo/oha/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "oha";
  };
}
