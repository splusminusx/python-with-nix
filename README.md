Dependencies:
- https://github.com/nix-community/poetry2nix
- https://github.com/numtide/flake-utils
- https://github.com/edolstra/flake-compat

Create a new flake from the [template](https://github.com/NixOS/templates)
```bash
$ nix flake new python-flake -t templates#python
```

Copy application code
```bash
$ cd python-flake
$ cp ../imageapp/pyproject.toml ./
$ cp ../imageapp/poetry.lock ./
$ cp ../imageapp/imageapp ./
```

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
nix flake check
```
