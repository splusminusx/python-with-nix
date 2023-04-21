## Python project scaffold with Poetry + Nix

Dependencies:
- https://github.com/nix-community/poetry2nix
- https://github.com/numtide/flake-utils
- https://github.com/edolstra/flake-compat
- https://github.com/cachix/pre-commit-hooks.nix
- https://github.com/hercules-ci/gitignore.nix

Build an app and run it
```bash
$ nix build .
$ result/bin/main
 * Serving Flask app 'imageapp'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://127.0.0.1:5000
Press CTRL+C to quit
```

Or simply run it
```bash
$ nix run .
```

Run checks
```bash
$ nix flake check
```

Run pre-commit checks on all files
```bash
$ nix develop --ignore-environment -f shell.nix -c pre-commit run --all-files
```

References:
- https://github.com/ibis-project/ibis-substrait
- [Writing your own Nix Flake checks](https://msfjarvis.dev/posts/writing-your-own-nix-flake-checks/)
- [How to Nixify a Python Project](https://altf4.wiki/t/how-to-nixify-a-python-project/126)
- [Tweag.io introduction post](https://www.tweag.io/blog/2020-08-12-poetry2nix/)
