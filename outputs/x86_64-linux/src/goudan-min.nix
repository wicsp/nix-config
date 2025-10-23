{
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
} @ args: let
  name = "goudan-min";
  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # Minimal, near-vanilla NixOS for goudan
      "hosts/goudan/minimal.nix"
    ];
    home-modules = [];
  };

  systemArgs = modules // args;
in {
  nixosConfigurations.${name} = mylib.nixosSystem systemArgs;

  # Optional: build an ISO for quick testing/rehydration
  packages.${name} = inputs.self.nixosConfigurations.${name}.config.formats.iso;
}
