{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  aiohttp,
  flake8,
  pytest,
  pytest-asyncio,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "throttler";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uburuntu";
    repo = "throttler";
    tag = "v${version}";
    hash = "sha256-fE35zPjBUn4e1VRkkIUMtYJ/+LbnUxnxyfnU+UEPwr4=";
  };

  checkInputs = [
    aiohttp
    flake8
    pytest
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/" ];

  disabledTestPaths = [
    # time sensitive tests
    "tests/test_execution_timer.py"
  ];

  meta = with lib; {
    description = "Zero-dependency Python package for easy throttling with asyncio support";
    homepage = "https://github.com/uburuntu/throttler";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
