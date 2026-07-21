{
  myvars,
  lib,
}:
let
  inherit (myvars) username;
  hosts = [
    "macsp"
  ];
in
lib.genAttrs hosts (_: "/Users/${username}")
