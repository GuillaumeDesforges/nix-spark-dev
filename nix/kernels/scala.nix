{ runCommand
, almond
, name ? "nixpkgs"
}:

let
  kernelFile = {
    language = "scala";
    display_name = "Scala ${almond.scalaVersion}";
    argv = [
      "${almond}/bin/almond"
      "--connection-file"
      "{connection_file}"
    ];

    logo64 = "logo-64x64.png";
  };

  scalaAlmondKernel = runCommand name { }
    (
      ''
        mkdir .jupyter
        ${almond}/bin/almond --install --jupyter-path .jupyter --command "${almond}/bin/almond"
        mkdir -p $out/kernels/almond
        cp .jupyter/scala/logo-64x64.png $out/kernels/almond/logo-64x64.png
        echo '${builtins.toJSON kernelFile}' > $out/kernels/almond/kernel.json
      ''
    );
in
{
  spec = scalaAlmondKernel;
  # runtimePackages = [
  # ];
}
