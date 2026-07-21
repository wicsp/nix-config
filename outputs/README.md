# Flake outputs

Outputs are grouped by target platform and loaded with Haumea.

```text
outputs/
├── default.nix
├── aarch64-darwin/
│   ├── default.nix
│   ├── src/
│   └── tests/
├── x86_64-home/
│   ├── default.nix
│   └── src/
└── x86_64-linux/
    ├── default.nix
    ├── src/
    └── tests/
```

## Evaluation tests

Each test directory contains `expr.nix` and `expected.nix`. In addition to focused assertions for
hostnames, kernels, and Home Manager paths, the top-level derivation tests force every exported
NixOS and Darwin system to evaluate far enough to catch removed options and missing module inputs.

Run all evaluation tests with:

```bash
just test
```

Run standard flake validation with:

```bash
nix flake check --no-build --show-trace
```

## NixOS integration tests

Service-level tests should use `pkgs.testers.runNixOSTest` and be exported as packages from the
relevant platform output. Prefer small tests around critical services over booting an entire desktop
host, which keeps CI fast and avoids unnecessary secret dependencies.
