# Repository Guidelines

## Project Structure & Module Organization

- Root flake: `flake.nix`, inputs pinned in `flake.lock`.
- Outputs: `outputs/` (split by system) aggregates `nixosConfigurations`, `darwinConfigurations`,
  `packages`, and `evalTests` via Haumea. Tests live under `outputs/*/tests`.
- Hosts: `hosts/<hostname>/` per machine. Keep host‑specific changes isolated.
- Modules: `modules/{nixos,darwin}/` reusable Nix modules; `home/{base,linux,darwin}/` Home‑Manager
  layers.
- Overlays & lib: `overlays/` (package overrides), `lib/` helpers.
- Infra & hardening: `infra/`, `hardening/` (apparmor, firejail, nixpaks), `certs/`, `secrets/`.
- Scripts & tools: `scripts/` (e.g., macOS helpers), `utils.sh` (bash helpers), `Justfile` task
  runner.

## Build, Test, and Development Commands

- List tasks: `just` (shows groups). If needed: `nix shell nixpkgs#just`.
- Format Nix: `just fmt` (runs `nix fmt`).
- Eval tests: `just test` (runs `nix eval .#lib.evalTests`).
- REPL: `just repl` → `nix repl -f flake:nixpkgs`.
- Update inputs: `just up` or `just upp <input>`.
- Build examples (no side effects):
  - Darwin: `nix build .#darwinConfigurations.harmonica.system`
  - NixOS: `nix build .#nixosConfigurations.goudan.config.system.build.toplevel`
- Switch locally only if you own the target:
  - macOS: `./result/sw/bin/darwin-rebuild switch --flake .#<host>` or `just ha`/`just macsp`.
  - NixOS: `sudo nixos-rebuild switch --flake .#<host>` or `just <host>-local`.

## Coding Style & Naming Conventions

- Nix: run `nix fmt` before commits; prefer 2‑space indentation, snake_case attrs, kebab‑case file
  names.
- Markdown/JSON/YAML: Prettier config in `.prettierrc.yaml` (e.g., `printWidth: 100`,
  `proseWrap: always`).
- Keep host directories named as the actual hostname; module files should be descriptive (e.g.,
  `networking.nix`).

## Testing Guidelines

- Place eval tests under `outputs/<system>/tests` and expose via `haumea.lib.loadEvalTests` (already
  aggregated under `.#lib.evalTests`).
- Run `just test` locally; add minimal, fast eval checks for critical modules.

## Commit & Pull Request Guidelines

- Commits: short, imperative; optionally prefix type (`feat:`, `fix:`, `chore:`). Example:
  `fix: update fcitx5 for qt6`.
- PRs: include scope (hosts/modules), rationale, and sample commands used (`just fmt`, `just test`,
  build lines). Link issues when relevant; screenshots only if UI‑facing.
- Required before merge: `just fmt` clean, `just test` green, builds succeed for affected hosts.

## Security & Configuration Tips

- Do not commit secrets; use the external secrets repo and `secrets/` integration (ragenix/agenix
  inputs). Redact tokens and IPs in PRs.
- Prefer build‑only checks in PRs; avoid switching remote hosts.
