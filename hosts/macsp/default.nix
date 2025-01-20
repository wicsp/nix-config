# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,  ... }:

{
  imports =
    [
      ../../modules/core.nix
      ../../modules/darwin.nix
    ];

  networking.hostName = "macsp"; # Define your hostname.
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  system = {
    stateVersion = 5;
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
    #   menuExtraClock.Show24Hour = true;  # show 24 hour clock
      # other macOS's defaults configuration.
      # ......
    };
  };


}


