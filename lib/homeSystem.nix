{
  lib,
  inputs,
  home-modules ? [],
  myvars,
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  ...
}: let
  inherit (inputs) nixpkgs home-manager;
in
  home-manager.lib.homeManagerConfiguration {
    inherit system;
    pkgs = nixpkgs.legacyPackages.${system};
    extraSpecialArgs = specialArgs;
    modules = home-modules;
  }
