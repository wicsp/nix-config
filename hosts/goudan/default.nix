{ myvars, lib, ... }:
#############################################################
#
#  Goudan - NixOS Desktop System
#
#############################################################
let
  hostName = "goudan"; # Define your hostname.
  # inherit (myvars.networking) mainGateway mainGateway6 nameservers;
  # inherit (myvars.networking.hostsAddr.${hostName}) iface ipv4 ipv6;
  # ipv4WithMask = "${ipv4}/24";
  # ipv6WithMask = "${ipv6}/64";
in
{
  imports = [
    ./netdev-mount.nix # TODO
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
    ./ai

    ./preservation.nix # TODO
    ./secureboot.nix # TODO
  ];

  services.sunshine.enable = lib.mkForce true;

  networking = {
    inherit hostName;

    # Use NetworkManager for Wi‑Fi/Ethernet (provides nmcli/nmtui)
    networkmanager.enable = true;
    # NetworkManager manages DHCP by default
  };

  # Ensure systemd-networkd is not used on this host
  networking.useNetworkd = false;
  systemd.network.enable = false;

  # systemd.network.networks."10-${iface}" = {
  #   matchConfig.Name = [ iface ];
  #   networkConfig = {
  #     Address = [
  #       ipv4WithMask
  #       ipv6WithMask
  #     ];
  #     DNS = nameservers;
  #     DHCP = "ipv6"; # enable DHCPv6 only, so we can get a GUA.
  #     IPv6AcceptRA = true; # for Stateless IPv6 Autoconfiguraton (SLAAC)
  #     LinkLocalAddressing = "ipv6";
  #   };
  #   routes = [
  #     {
  #       Destination = "0.0.0.0/0";
  #       Gateway = mainGateway;
  #     }
  #     {
  #       Destination = "::/0";
  #       Gateway = mainGateway6;
  #       GatewayOnLink = true; # it's a gateway on local link.
  #     }
  #   ];
  #   linkConfig.RequiredForOnline = "routable";
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
