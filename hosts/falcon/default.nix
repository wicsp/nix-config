{ lib, myvars, ... }:
#############################################################
#
#  Mio - Aliyun Server, for general purpose server tasks.
#
#############################################################
let
  hostName = "falcon"; # Define your hostname.
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./hysteria.nix
  ];

  networking = {
    inherit hostName;
    # inherit (myvars.networking) defaultGateway nameservers;
    # inherit (myvars.networking.hostsInterface.${hostName}) interfaces;

    # Server networking
    networkmanager.enable = true;
  };

  networking.firewall.enable = true;

  # Enable tailscale
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
