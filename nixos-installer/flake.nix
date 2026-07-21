{
  description = "Host-specific NixOS installer configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      installerHostsDir = ./hosts;
      installerHostFiles = lib.attrNames (
        lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
          builtins.readDir installerHostsDir
        )
      );

      mkInstallerSystem =
        file:
        let
          profile = import (installerHostsDir + "/${file}") { inherit inputs lib; };
          name = profile.name or (lib.removeSuffix ".nix" file);
        in
        lib.nameValuePair name (
          nixpkgs.lib.nixosSystem {
            system = profile.system or "x86_64-linux";
            specialArgs = inputs // {
              myvars.username = profile.username or "wicsp";
              myvars.userfullname = profile.userfullname or "WICSP";
            };
            modules = [
              { networking.hostName = profile.hostname or name; }
              ./configuration.nix
              ../modules/base.nix
              ../modules/nixos/base/i18n.nix
              ../modules/nixos/base/user-group.nix
              ../modules/nixos/base/networking.nix
            ]
            ++ profile.modules;
          }
        );
    in
    {
      nixosConfigurations = lib.listToAttrs (map mkInstallerSystem installerHostFiles);
    };
}
