{ lib, stdenv, jdk, jre, scala, coursier, makeWrapper }:

let
  baseName = "almond";
  version = "0.11.2";
  scalaVersion = "2.13.4";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";

    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch -r jitpack sh.almond:scala-kernel_${scalaVersion}:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';


    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "YfHUwlKhJSwYcgBPfwQqU1yWyaGclqljX7iNfgl8Vos=";
  };
in
stdenv.mkDerivation {
  pname = baseName;
  inherit version;
  inherit scalaVersion;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH almond.ScalaKernel"

    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  meta = with lib; {
    description = "A Scala kernel for Jupyter";
    homepage = "https://github.com/almond-sh/almond";
    license = licenses.bsd3;
    maintainers = [ maintainers.GuillaumeDesforges ];
  };
}
