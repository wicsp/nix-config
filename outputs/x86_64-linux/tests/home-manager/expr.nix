{
  myvars,
  lib,
  outputs,
}:
let
  inherit (myvars) username;
  hosts = [
    "goudan"
    "goudan-hyprland"
    "mio"
  ];
in
lib.genAttrs hosts (
  name: outputs.nixosConfigurations.${name}.config.home-manager.users.${username}.home.homeDirectory
)
