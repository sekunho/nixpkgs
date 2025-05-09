{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.20.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/vG5LkQiA8iPP+UV1opLeJwbYfmzqYwpsoMizpGT98o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GBr0z2iJuk86xkgZd2sAz+ISTRfESDt99g6ssxXhzhI=";

  nativeBuildInputs = [ installShellFiles ];

  useNextest = true;

  postInstall = ''
    $out/bin/the-way config default tmp.toml
    for shell in bash fish zsh; do
      THE_WAY_CONFIG=tmp.toml $out/bin/the-way complete $shell > the-way.$shell
      installShellCompletion the-way.$shell
    done
  '';

  meta = with lib; {
    description = "Terminal code snippets manager";
    mainProgram = "the-way";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    changelog = "https://github.com/out-of-cheese-error/the-way/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      figsoda
      numkem
    ];
  };
}
