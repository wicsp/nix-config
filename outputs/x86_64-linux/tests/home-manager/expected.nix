{
  myvars,
  lib,
}:
let
  username = myvars.username;
  hosts = [
    "goudan"
    "goudan-hyprland"
    "mio"
  ];
in
lib.genAttrs hosts (_: "/home/${username}")
