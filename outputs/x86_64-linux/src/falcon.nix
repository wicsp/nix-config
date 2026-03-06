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
  name = "falcon";
  tags = [
    name
    "server"
  ];
  ssh-user = "root";
  modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        # common
        "secrets/nixos.nix" # TODO
        "modules/nixos/server/server.nix"
        # host specific
        "hosts/${name}"
        # nixos hardening
        # "hardening/profiles/default.nix"
        # "hardening/nixpaks"
        # "hardening/bwraps"
      ])
      ++ [
        { modules.secrets.server.application.enable = true; }
        { modules.secrets.server.operation.enable = true; }
        { modules.secrets.server.webserver.enable = true; }
        { modules.secrets.server.storage.enable = true; }
      ];
    home-modules = map mylib.relativeToRoot [
      # common - use minimal set for falcon (40G disk, space constrained)
      # "home/linux/tui.nix"  # too heavy: pulls in dev-tools, k8s, editors/LSPs
      "home/base/core" # core CLI tools (eza, bat, fzf, zoxide, atuin, etc.)
      "home/base/home.nix" # home-manager base config
      "home/linux/base" # linux-specific base tools
      # host specific
      "hosts/${name}/home.nix"
    ];

  };

  systemArgs = modules // args;
in
{
  nixosConfigurations.${name} = mylib.nixosSystem systemArgs;

  colmena.${name} = mylib.colmenaSystem (systemArgs // { inherit tags ssh-user; });

  packages.${name} = inputs.self.nixosConfigurations.${name}.config.formats.kubevirt; # TODO
}
