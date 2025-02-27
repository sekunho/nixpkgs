{
  lib,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "moat-ble";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "moat-ble";
    tag = "v${version}";
    hash = "sha256-dy1Fm0Z1PUsPY8QTiXUcWSi+csFnTUsobSkA92m06QI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "moat_ble" ];

  meta = with lib; {
    description = "Library for Moat BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/moat-ble";
    changelog = "https://github.com/Bluetooth-Devices/moat-ble/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
