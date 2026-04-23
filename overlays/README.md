# Overlays

Overlays for both NixOS and Nix-Darwin.

If you don't know much about overlays, it is recommended to learn the function and usage of overlays
through [Overlays - NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/nixpkgs/overlays).

## Current Structure

```
overlays/
├── README.md
├── default.nix          # Entrypoint for all overlays
└── fcitx5/              # Chinese input method configuration
    ├── README.md
    ├── default.nix      # fcitx5 overlay definition
    └── rime-data-yuling/ # Custom rime data for 灵明输入法
        └── share/
            └── rime-data/
                ├── default.custom.yaml
                ├── lua/
                │   └── yuhao/
                ├── squirrel.custom.yaml
                ├── yuhao/
                ├── yuling.custom.yaml
                ├── yuling.dict.yaml
                ├── yuling.schema.yaml
                ├── yuling_fluency.schema.yaml
                └── ...
```

## Components

### 1. `default.nix`

The entrypoint of overlays, it execute and import all overlay files in the current directory with
the given args.

### 2. `fcitx5`

fcitx5's overlay, add my customized Chinese input method - [灵明输入法](https://shurufa.app/)

This overlay provides:

- Custom rime data for 灵明输入法 (Yuling input method)
- Cross-platform support for both Linux (fcitx5-rime) and macOS (squirrel)
- Pre-configured input method settings
