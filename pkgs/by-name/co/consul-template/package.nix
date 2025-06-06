{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "consul-template";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    hash = "sha256-rPr69/U7+TZ7snzK8dvyd+5/O9/sqKMY/sIPOGkORs4=";
  };

  vendorHash = "sha256-VUqRNK6OwSVydVbmxDe75JnI16JpnGT+wyAItqz781Q=";

  # consul-template tests depend on vault and consul services running to
  # execute tests so we skip them here
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) consul-template;
  };

  meta = with lib; {
    homepage = "https://github.com/hashicorp/consul-template/";
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [
      cpcloud
      pradeepchhetri
    ];
    mainProgram = "consul-template";
  };
}
