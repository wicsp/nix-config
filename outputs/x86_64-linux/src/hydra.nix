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
  tags = [
    name
    "server"
  ];
  ssh-user = "root";
  modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        # common
        "secrets/nixos.nix"
        # minimal bootstrap stack
        "modules/nixos/server/server.nix"
        # host specific
        "hosts/${name}"
      ])
      ++ [
        # Enable the shared agenix chain and operational secrets such as the
        # remote-builder SSH key. Additional server secret categories can be
        # turned on later as the host starts consuming them.
        { modules.secrets.server.operation.enable = true; }
      ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/linux/tui.nix"
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
        ;
    }
  );

  # Keep ISO format for a simple bootstrap artifact.
  packages.${name} = inputs.self.nixosConfigurations.${name}.config.formats.iso;
}
