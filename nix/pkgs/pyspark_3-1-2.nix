{ lib
, buildPythonPackage
, fetchPypi
, py4j
}:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "XiXrsYdW6XFfTSaEjMflWANQJdp0tPwyWg68Bf9TjmU=";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py
    substituteInPlace setup.py \
      --replace py4j==0.10.9 'py4j>=0.10.9,<0.11'
  '';

  propagatedBuildInputs = [
    py4j
  ];

  # Tests assume running spark instance
  doCheck = false;

  pythonImportsCheck = [
    "pyspark"
  ];

  meta = with lib; {
    description = "Python bindings for Apache Spark";
    homepage = "https://github.com/apache/spark/tree/master/python";
    license = licenses.asl20;
    maintainers = [ maintainers.shlevy ];
  };
}