final: _:
let
  overrides = [
    final.poetry2nix.defaultPoetryOverrides
  ];

  mkPoetryEnv = python: final.poetry2nix.mkPoetryEnv {
    inherit python overrides;
    projectDir = ../.;
    editablePackageSources = {
      imageapp = ../imageapp;
    };
    groups = [ "dev" "types" "test" ];
    preferWheels = true;
  };

  mkApp =
    python:
    let
      drv = { poetry2nix, python, lib }: poetry2nix.mkPoetryApplication {
        inherit python overrides;

        projectDir = ../.;
        src = lib.cleanSource ../.;

        checkGroups = [ "test" ];
        preferWheels = true;

        checkPhase = ''
          runHook preCheck
          pytest
          runHook postCheck
        '';

        pythonImportsCheck = [ "imageapp" ];
      };
    in
    final.callPackage drv { inherit python; };
in
{
  imageappEnv39 = mkPoetryEnv final.python39;
  imageapp39 = mkApp final.python39;
}
