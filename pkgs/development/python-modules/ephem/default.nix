{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "ephem";
  version = "4.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DtLk6nb52z7t4iBK2rivPxcIIBx8BO6FEecQpUymQl8=";
  };

  nativeCheckInputs = [
    pytest
  ];

  # JPLTest uses assets not distributed in package
  checkPhase = ''
    pytest --pyargs ephem.tests -k "not JPLTest"
  '';

  pythonImportsCheck = [ "ephem" ];

  meta = with lib; {
    description = "Compute positions of the planets and stars";
    homepage = "https://github.com/brandon-rhodes/pyephem";
    license = licenses.mit;
    maintainers = with maintainers; [ chrisrosset ];
  };
}
