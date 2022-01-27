{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.jupyterWith.url = "github:tweag/jupyterWith";

  outputs = { self, nixpkgs, flake-utils, jupyterWith }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlay = import ./nix/overlay.nix;
          pkgs = import nixpkgs {
            inherit system;
            # allowUnsupportedSystem = true;
            overlays = [
              jupyterWith.overlays.jupyterWith
              jupyterWith.overlays.python
              overlay
            ];
          };
        in
        {
          devShell = pkgs.callPackage ./nix/devShell.nix { };
        }
      );
}
