# Hosts

1. `darwin`(macOS)
   1. `macsp`: current nix-darwin machine.
1. `linux`
   1. `goudan`: main desktop, default profile is `niri`.
   2. `falcon`
   3. `hydra`
   4. `mio`
   5. `nexus`
1. Other aarch64/riscv64 SBCs:
   [ryan4yin/nixos-config-sbc](https://github.com/ryan4yin/nixos-config-sbc)

## How to add a new host

1. Under `hosts/`
   1. Create a new folder under `hosts/` with the name of the new host.
   2. Create & add the new host's `hardware-configuration.nix` to the new folder, and add the new
      host's `configuration.nix` to `hosts/<name>/default.nix`.
   3. If the new host need to use home-manager, add its custom config into `hosts/<name>/home.nix`.
1. Under `outputs/`
   1. Add a new nix file named `outputs/<system-architecture>/src/<name>.nix`.
   2. Copy the content from one of the existing similar host, and modify it to fit the new host.
      1. Usually, you only need to modify the `name` and `tags` fields.
   3. [Optional] Add a new unit test file under `outputs/<system-architecture>/tests/<name>.nix` to
      test the new host's nix file.
   4. [Optional] Add a new integration test file under
      `outputs/<system-architecture>/integration-tests/<name>.nix` to test whether the new host's
      nix config can be built and deployed correctly.
1. Under `vars/networking.nix`
   1. Add the new host's static IP address.
   1. Skip this step if the new host is not in the local network or is a mobile device.

## rolling girls

My All RISCV64 hosts.

![](/_img/nixos-riscv-cluster.webp)

## Distributed Building

I usually run the build command on `Ai` and nix will distribute the build to other NixOS machines,
which is convenient and fast.

When building some packages for riscv64 or aarch64, I often have no cache available because of
various changes under the hood, so I need to build much more packages than usual, which is one of
the reasons why the cluster was originally built, and another reason is distributed building is
cool!

![](/_img/nix-distributed-building.webp)

![](/_img/nix-distributed-building-log.webp)

## References

[The Rolling Girls【ローリング☆ガールズ】 - Wikipedia](https://en.wikipedia.org/wiki/The_Rolling_Girls):

![](/_img/rolling_girls.webp)

[List of Frieren characters](https://en.wikipedia.org/wiki/List_of_Frieren_characters)
