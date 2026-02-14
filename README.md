# Personal Site

Personal homepage built with Hugo and the PaperMod theme.

## Prerequisites

- Either:
  - Install Hugo directly
  - Install Nix and run `nix develop`
- Optional:
  - `direnv` for automatically loading the Nix dev shell (`use flake`)

## Development

- Resolve dependencies (theme submodule):
  - `make deps`
- Run local server:
  - `make dev`
- Build site:
  - `make build`
- Clean generated files:
  - `make clean`

## Docker

- Build image (local baseURL):
  - `make docker-build`
- Run image:
  - `make docker-run`
- Visit:
  - http://localhost:8080/

## Deployment

Public URL: https://profile.neodymium6.net/

## Notes

- Theme: PaperMod (as a git submodule)
