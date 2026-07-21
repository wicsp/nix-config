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
  niri,
  ...
}@args:
let
  name = "goudan";
  tags = [
    name
    "desktop"
  ];
  ssh-user = "root";
  base-modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        # common
        "secrets/nixos.nix" # TODO
        "modules/nixos/desktop.nix"
        # host specific
        "hosts/${name}"
        # nixos hardening
        # "hardening/profiles/default.nix"
        "hardening/nixpaks"
        "hardening/bwraps"
      ])
      ++ [
        inputs.niri.nixosModules.niri
        {
          modules = {
            desktop = {
              fonts.enable = true;
              wayland.enable = true;
              gaming.enable = true;
            };
            secrets = {
              desktop.enable = true;
              preservation.enable = true;
            };
          };
        }
      ];
    home-modules =
      (map mylib.relativeToRoot [
        # common
        "home/linux/gui.nix"
        # host specific
        "hosts/${name}/home.nix"
      ])
      ++ [
        {
          modules.desktop.gaming.enable = true;
          modules.desktop.noctalia.enable = true;
        }
      ];
  };

  modules-hyprland = {
    inherit (base-modules) nixos-modules;
    home-modules = [
      { modules.desktop.hyprland.enable = true; }
    ]
    ++ base-modules.home-modules;
  };

  modules-niri = {
    nixos-modules = [
      { programs.niri.enable = true; }
    ]
    ++ base-modules.nixos-modules;
    home-modules = [
      { modules.desktop.niri.enable = true; }
    ]
    ++ base-modules.home-modules;
  };
in
{
  nixosConfigurations = {
    # host with hyprland compositor
    "${name}" = mylib.nixosSystem (modules-niri // args);
    "${name}-hyprland" = mylib.nixosSystem (modules-hyprland // args);
    "${name}-niri" = mylib.nixosSystem (modules-niri // args);
  };

  colmena.${name} = mylib.colmenaSystem ((modules-niri // args) // { inherit tags ssh-user; });

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}-hyprland" = inputs.self.nixosConfigurations."${name}-hyprland".config.formats.iso;
    "${name}-niri" = inputs.self.nixosConfigurations."${name}-niri".config.formats.iso;
  };
}
