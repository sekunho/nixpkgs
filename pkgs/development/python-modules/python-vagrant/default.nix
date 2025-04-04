{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "python-vagrant";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "python-vagrant";
    tag = "v${version}";
    hash = "sha256-apvYzH0IY6ZyUP/FiOVbGN3dXejgN7gn7Mq2tlEaTww=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  # The tests try to connect to qemu
  doCheck = false;

  pythonImportsCheck = [ "vagrant" ];

  meta = {
    description = "Python module that provides a thin wrapper around the vagrant command line executable";
    homepage = "https://github.com/todddeluca/python-vagrant";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pmiddend ];
  };
}
