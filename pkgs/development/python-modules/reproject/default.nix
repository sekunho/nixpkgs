{
  lib,
  astropy,
  astropy-extension-helpers,
  astropy-healpix,
  buildPythonPackage,
  cloudpickle,
  cython,
  dask,
  fetchPypi,
  fsspec,
  numpy,
  pytest-astropy,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools-scm,
  zarr,
}:

buildPythonPackage rec {
  pname = "reproject";
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U8jqJ5uLVX8zoeQwr14FPNdHACRA4HK65q2TAtRr5Xk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "cython==" "cython>="
  '';

  nativeBuildInputs = [
    astropy-extension-helpers
    cython
    numpy
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    astropy-healpix
    cloudpickle
    dask
    fsspec
    numpy
    scipy
    zarr
  ]
  ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "build/lib*"
    # Avoid failure due to user warning: Distutils was imported before Setuptools
    "-p no:warnings"
    # Uses network
    "--ignore build/lib*/reproject/interpolation/"
    # prevent "'filterwarnings' not found in `markers` configuration option" error
    "-o 'markers=filterwarnings'"
  ];

  pythonImportsCheck = [ "reproject" ];

  meta = with lib; {
    description = "Reproject astronomical images";
    downloadPage = "https://github.com/astropy/reproject";
    homepage = "https://reproject.readthedocs.io";
    changelog = "https://github.com/astropy/reproject/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
  };
}
