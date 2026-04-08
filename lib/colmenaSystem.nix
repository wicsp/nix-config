# colmena - Remote Deployment via SSH
{
  lib,
  inputs,
  nixos-modules,
  home-modules ? [ ],
  myvars,
  system,
  tags,
  ssh-user,
  targetHost ? null,
  targetPort ? null,
  buildOnTarget ? true,
  replaceUnknownProfiles ? true,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  ...
}:
let
  inherit (inputs) home-manager;
in
{ name, ... }:
{
  deployment = {
    inherit tags;
    targetUser = ssh-user;
    targetHost = if targetHost != null then targetHost else name; # hostName or IP address
    inherit
      buildOnTarget
      replaceUnknownProfiles
      ;
  }
  // (lib.optionalAttrs (targetPort != null) { inherit targetPort; });

  imports =
    nixos-modules
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "home-manager.backup";

        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users."${myvars.username}".imports = home-modules;
      }
    ]);
}
