{ lib, pkgs, ... }:
#############################################################
#
#  Mio - Aliyun Server, for general purpose server tasks.
#
#############################################################
let
  hostName = "mio"; # Define your hostname.
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

  # Bootstrap stage: avoid depending on remote-builder secrets.
  # Re-enable distributed builds when amax builder key is provisioned.

  # Aliyun mainland host: prefer a domestic cache mirror, keep official
  # cache and nix-community as fallbacks for paths the mirror lacks.
  nix.settings = {
    substituters = lib.mkForce [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    connect-timeout = 10;
    fallback = true;

    trusted-public-keys = lib.mkForce [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
