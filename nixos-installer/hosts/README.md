# Installer Hosts

Copy [./example.nix.example](./example.nix.example) to `<name>.nix`, then edit it for the machine
you want to bootstrap from the installer flake.

Example:

```nix
{
  name = "newbox";
  system = "x86_64-linux";
  hostname = "newbox";
  username = "wicsp";
  userfullname = "WICSP";
  modules = [
    ../../hosts/newbox/hardware-configuration.nix
    ../../hosts/newbox/impermanence.nix
  ];
}
```

Only files ending in `.nix` are loaded by the installer flake, so `.nix.example` files are kept as
templates only.

Then build or install it with:

```bash
nix build .#nixosConfigurations.newbox.config.system.build.toplevel
```
