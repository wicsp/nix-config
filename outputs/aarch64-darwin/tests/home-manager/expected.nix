{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "macsp"
  ];
in
  lib.genAttrs hosts (_: "/Users/${username}")
