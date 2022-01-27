final: prev:
let
  packageOverrides = selfPythonPackages: pythonPackages: {
    pyspark_3-1-2 = selfPythonPackages.callPackage ./pkgs/pyspark_3-1-2.nix { };
  };

in
{
  python3 = prev.python3.override (old: {
    packageOverrides =
      prev.lib.composeExtensions
        (old.packageOverrides or (_: _: { }))
        packageOverrides;
  });
}
