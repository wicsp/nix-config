{ myvars, ... }:
#############################################################
#
#  Mio - Aliyun Server, for general purpose server tasks.
#
#############################################################
let
  hostName = "nexus"; # Define your hostname.
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking = {
    inherit hostName;
    # inherit (myvars.networking) defaultGateway nameservers;
    # inherit (myvars.networking.hostsInterface.${hostName}) interfaces;

    # Server networking
    networkmanager.enable = true;
  };

  # Enable tailscale
  services.tailscale.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
