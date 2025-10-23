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
} @ args: let
  name = "goudan";
  tags = [name "server"];
  ssh-user = "root";

  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "secrets/nixos.nix"
      "modules/nixos/server/server.nix"
      # host specific
      "hosts/${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      # Minimal TUI home like mio
      "home/linux/tui.nix"
      # host specific
      "hosts/${name}/home.nix"
    ];
  };

  systemArgs = modules // args;
in {
  nixosConfigurations.${name} = mylib.nixosSystem systemArgs;

  # Enable colmena for remote deployment
  colmena.${name} = mylib.colmenaSystem (systemArgs // {inherit tags ssh-user;});

  # Generate ISO for server installation
  packages.${name} = inputs.self.nixosConfigurations.${name}.config.formats.iso;
}
