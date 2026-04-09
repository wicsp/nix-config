{ lib, pkgs, ... }:
#############################################################
#
#  Hydra - Minimal bootstrap profile after nixos-infect.
#
#############################################################
let
  hostName = "hydra"; # Define your hostname.
in
{
  imports = [
    # Keep only hardware scan for bootstrap phase.
    ./hardware-configuration.nix
  ];

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  # Minimal remote management baseline.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };
  services.tailscale.enable = true;
  # Override nix settings for US server - don't use Chinese mirrors
  nix.settings = {
    substituters = lib.mkForce [
      # Official cache (default)
      "https://cache.nixos.org"
      # Community cache
      "https://nix-community.cachix.org"
      # Optional: Add US-based mirrors if available
      # "https://nixos-cache.example.com"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
