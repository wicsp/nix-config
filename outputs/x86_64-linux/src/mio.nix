{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
}@args:
let
  name = "mio";
  tags = [
    name
    "server"
  ];
  ssh-user = "root";
  # Public IP for bootstrap phase before tailscale is ready.
  targetHost = "8.135.45.26";

  modules = {
    nixos-modules = (
      map mylib.relativeToRoot [
        # minimal bootstrap stack
        "modules/nixos/server/server.nix"
        # host specific
        "hosts/${name}"
      ]
    );
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
        targetHost
        ;
    }
  );

  # Generate ISO for bootstrap/recovery scenarios.
  packages.${name} = inputs.self.nixosConfigurations.${name}.config.formats.iso;
}
