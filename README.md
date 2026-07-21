# WICSP's Nix Config

Declarative configuration for my NixOS, nix-darwin, Home Manager, and homelab systems.

## Systems

| Output                   | Role                             | Platform       |
| ------------------------ | -------------------------------- | -------------- |
| `goudan` / `goudan-niri` | Niri desktop with Noctalia       | x86_64-linux   |
| `goudan-hyprland`        | Hyprland desktop with Noctalia   | x86_64-linux   |
| `mio`                    | Minimal homelab server           | x86_64-linux   |
| `nexus`                  | KubeVirt/server host             | x86_64-linux   |
| `macsp`                  | nix-darwin workstation           | aarch64-darwin |
| `amax`, `cs`, `ynlab`    | Standalone Home Manager profiles | x86_64-linux   |

Host-specific configuration lives in [`hosts/`](./hosts), reusable system modules in
[`modules/`](./modules), and Home Manager layers in [`home/`](./home).

## Desktop

The default NixOS desktop uses Niri and Noctalia. Noctalia provides the bar, launcher,
notifications, lock screen, OSD, and session menu. A Hyprland variant remains available as
`goudan-hyprland`.

The shared Home Manager configuration includes terminal applications, development tools, editors,
Fcitx5/Rime, media tools, and Wayland integration.

## Secrets

Age-encrypted payloads come from the private `mysecrets` flake input. The tracked files under
[`secrets/`](./secrets) only declare how those payloads are deployed.

Base NixOS modules deliberately do not depend on decrypted secrets. Secret-backed features belong to
desktop, server-role, or host-specific modules so bootstrap and evaluation remain possible.

## Common commands

```bash
# List tasks
just

# Format tracked Nix files
just fmt

# Run fast evaluation tests, including complete host derivation evaluation
just test

# Validate standard flake outputs without building
nix flake check --no-build --show-trace

# Build without switching
nix build .#nixosConfigurations.goudan.config.system.build.toplevel
nix build .#darwinConfigurations.macsp.system

# Switch the current machine based on its hostname
just local

# Deploy selected Colmena nodes
just remote mio
```

Switch commands are intended only for machines owned by this configuration. Prefer build/evaluation
checks before activation.

## Repository layout

```text
flake.nix                 Flake inputs and output entry point
outputs/                  Per-platform hosts, packages, and evaluation tests
hosts/                    Machine-specific NixOS/Home Manager configuration
modules/                  Shared NixOS, Darwin, and cross-platform modules
home/                     Shared Home Manager layers
lib/                      Constructors and helper functions
overlays/                 Package overrides and Rime data
hardening/                Nixpak, bubblewrap, and AppArmor profiles
infra/                    Infrastructure configuration
nixos-installer/          Installation environment
scripts/                  Maintenance helpers
```

## Validation policy

Every exported NixOS and Darwin configuration must evaluate its top-level derivation. GitHub Actions
runs formatting, evaluation tests, and `nix flake check --no-build` using evaluation-only secret
fixtures. Changes affecting a host should additionally build that host before activation.

## Acknowledgements

This repository originally drew heavily from
[Ryan4Yin's nix-config](https://github.com/ryan4yin/nix-config) and the
[NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/).
