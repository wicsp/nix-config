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
  nix = {
    # nixos-infect often leaves an old nix-daemon (e.g. 2.18.x) that fails on modules-shrunk paths.
    package = pkgs.nixVersions.latest;
    distributedBuilds = lib.mkForce false;
    buildMachines = lib.mkForce [ ];
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
