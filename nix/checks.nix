{ self, pre-commit-hooks, ... }:

system:

with self.nixpkgs.${system};
{
  pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      actionlint.enable = true; # link GitHub Actions definitions
      deadnix.enable = true; # scan .nix files for dead code
      shellcheck.enable = true; # static analyis tool for shell scripts
      statix.enable = true; # ints and suggestions for the nix programming language
      nixpkgs-fmt.enable = true; # format .nix files

      ruffnix = {
        enable = true;
        entry = "ruff --force-exclude";
        types = [ "python" ];
        excludes = [ ];
      };

      black = {
        enable = true;
        excludes = [ ];
      };

      mypynix = {
        enable = true;
        entry = "mypy";
        types = [ "python" ];
        excludes = [
          "((tests|docs)/.+|build)\\.py"
        ];
      };

      shfmt = {
        enable = true;
        entry = lib.mkForce "${pkgs.shfmt}/bin/shfmt -i 2 -sr -d -s -l";
      };
    };
  };
}
