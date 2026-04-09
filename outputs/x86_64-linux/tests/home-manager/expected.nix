{
  myvars,
  lib,
}:
let
  username = myvars.username;
  hosts = [
    "goudan"
    "goudan-hyprland"
    "hydra"
    "mio"
  ];
in
lib.genAttrs hosts (_: "/home/${username}")
