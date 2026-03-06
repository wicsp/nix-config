{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      # IDEs
      # jetbrains.idea-community
    ]
    ++ (lib.optionals pkgs.stdenv.isx86_64 [
      insomnia # REST client
    ]);
}
