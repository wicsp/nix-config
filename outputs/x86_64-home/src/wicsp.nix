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
} @ args: let
  name = "wicsp";
  modules = map mylib.relativeToRoot [
    # "hosts/wicsp/home.nix"
    "home/linux/tui.nix"
    "modules/nixos/server/homeserver.nix"
  ];

  systemArgs = modules // args;
in {
  # macOS's configuration
  homeConfigurations.${name} = mylib.homeSystem systemArgs;
}
