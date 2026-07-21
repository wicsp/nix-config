{
  myvars,
  lib,
}:
let
  inherit (myvars) username;
  hosts = [
    "goudan"
    "goudan-hyprland"
    "mio"
  ];
in
lib.genAttrs hosts (_: "/home/${username}")
