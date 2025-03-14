{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  setuptools,
  jdk11,
  psutil,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "adb-enhanced";
  version = "2.5.24";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ashishb";
    repo = "adb-enhanced";
    tag = version;
    hash = "sha256-0HxeL6VGM+HTiAxs3NFRcEFbmH9q+0/pJdGyF1hl4hU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    psutil
    docopt
  ];

  postPatch = ''
    substituteInPlace adbe/adb_enhanced.py \
      --replace-fail "cmd = 'java" "cmd = '${jdk11}/bin/java"
  '';

  # Disable tests because they require a dedicated Android emulator
  doCheck = false;

  pythonImportsCheck = [ "adbe" ];

  meta = with lib; {
    description = "Tool for Android testing and development";
    homepage = "https://github.com/ashishb/adb-enhanced";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ vtuan10 ];
    mainProgram = "adbe";
  };
}
