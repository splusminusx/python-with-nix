{
  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable-small";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, gitignore, pre-commit-hooks, poetry2nix, ... }@inputs: {
    overlays.default = nixpkgs.lib.composeManyExtensions [
      gitignore.overlay
      poetry2nix.overlay
      (import ./nix/overlay.nix)
    ];
  } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      };
    in
    rec {
      nixpkgs = pkgs;

      packages = {
        default = pkgs.imageapp39;
      };

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          poetry
          actionlint
          git
          just
          nixpkgs-fmt
          pre-commit
          shellcheck
          shfmt
          statix
          imageappEnv39
        ];
      };

      apps.default = {
        program = "${packages.default}/bin/main";
        type = "app";
      };

      checks = {
        lint = pkgs.stdenv.mkDerivation {
          dontPatch = true;
          dontConfigure = true;
          dontBuild = true;
          dontInstall = true;
          doCheck = true;
          name = "lint";
          src = ./.;
          checkInputs = [ pkgs.imageappEnv39 ];
          checkPhase = ''
            mkdir -p $out
            flake8 . --count --show-source --statistics
          '';
        };

        tests = pkgs.stdenv.mkDerivation {
          dontPatch = true;
          dontConfigure = true;
          dontBuild = true;
          dontInstall = true;
          doCheck = true;
          name = "test";
          src = ./.;
          checkInputs = [ pkgs.imageappEnv39 ];
          checkPhase = ''
            mkdir -p $out
            pytest
          '';
        };

        pre-commit-check = (import ./nix/checks.nix inputs system).pre-commit-check;
      };
    });
}
