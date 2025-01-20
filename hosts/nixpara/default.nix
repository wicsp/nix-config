# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,  ... }:

{
  imports =
    [
      ../../modules/core.nix
      ../../modules/nixos.nix
      ../../modules/ssh.nix
      ../../modules/gui.nix
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
    };
  };

  networking.hostName = "nixpara"; 
  networking.proxy.default = "http://10.211.55.2:7890";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  system.stateVersion = "24.11"; 

}


