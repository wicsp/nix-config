{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
}@args:
let
  name = "hydra";
  targetHost = "100.100.10.7";
  tags = [
    name
    "server"
  ];
  ssh-user = "root";
  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "secrets/nixos.nix"
      # minimal bootstrap stack
      "modules/nixos/server/server.nix"
      # host specific
      "hosts/${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/linux/server.nix"
      # host specific
      "hosts/${name}/home.nix"
    ];
  };

  systemArgs = modules // args;
in
{
  nixosConfigurations.${name} = mylib.nixosSystem systemArgs;

  colmena.${name} = mylib.colmenaSystem (
    systemArgs
    // {
      inherit
        tags
        ssh-user
        targetHost
        ;
    }
  );

  # Keep ISO format for a simple bootstrap artifact.
  packages.${name} = inputs.self.nixosConfigurations.${name}.config.formats.iso;
}
