# sh.roz.ninja

Collection of curlable shell scripts served at `https://sh.roz.ninja/<script-name>`.

Scripts are meant to be run via `curl -sSL https://sh.roz.ninja/<name> | bash` (or piped to the appropriate shell).

## Conventions

- Each script is a standalone file at the repo root (e.g. `install.sh` → `https://sh.roz.ninja/install.sh`).
- Scripts should start with a shebang (`#!/bin/bash`, `#!/bin/sh`, etc.) and `set -e`.
- Scripts must be self-contained — no dependencies on other files in this repo.
- Keep scripts portable where possible; if OS-specific, detect and bail early with a clear message.
- Use [Conventional Commits](https://www.conventionalcommits.org/) for all commit messages (e.g. `feat:`, `fix:`, `docs:`, `chore:`).
