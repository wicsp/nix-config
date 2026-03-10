{
  myvars,
  lib,
}:
let
  username = myvars.username;
  hosts = [
    "ai-hyprland"
    "ai-niri"
    "ruby"
  ];
in
lib.genAttrs hosts (_: "/home/${username}")
