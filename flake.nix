{
  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
    nixpkgs.follows = "dream2nix/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    dream2nix,
    nixpkgs,
    flake-utils
  }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
      packages.default = dream2nix.lib.evalModules {
        packageSets.nixpkgs = pkgs;
        modules = [
          dream2nix.modules.dream2nix.pip
          {
            paths.projectRoot = ./.;
            paths.projectRootFile = "flake.nix";
            paths.package = ./.;
          }
          ({ config, ... }: let
            name = "codexctl";
            version = "2025-07-19 18:10";

          in {
            inherit name version;
            deps = { nixpkgs, ... }: { python = nixpkgs.python312; };
            pip.requirementsList = [
              "poetry-core"

              "paramiko==3.4.1"
              "psutil==6.0.0"
              "requests==2.32.4"
              "loguru==0.7.3"
              "remarkable-update-image==1.1.6; sys_platform != 'linux'"
              "remarkable-update-fuse==1.2.4; sys_platform == 'linux'"
            ];
            pip.flattenDependencies = true; # Build application instead of package.

            mkDerivation = {
              src = ./.;
            };
            buildPythonPackage.pyproject = true;
          })
        ];
      };
  });
}
