{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    (lib.optionals pkgs.stdenv.isx86_64 [
      insomnia # REST client
    ]);
}
