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

  modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        # common
        "secrets/nixos.nix"
        "modules/nixos/server/server.nix"
        # host specific
        "hosts/${name}"
      ])
      ++ [
        {
          # Enable any specific secrets or features for mio here
          # modules.secrets.server.enable = true;
        }
      ];
    home-modules = map mylib.relativeToRoot [
      # Basic home manager config for server (minimal TUI tools)
      "home/linux/tui.nix"
      # host specific home config
      "hosts/${name}/home.nix"
    ];
  };

  systemArgs = modules // args;
in
{
  nixosConfigurations.${name} = mylib.nixosSystem systemArgs;

  # Generate ISO for server installation
  packages.${name} = inputs.self.nixosConfigurations.${name}.config.formats.iso;
}
