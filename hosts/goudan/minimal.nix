{
  pkgs,
  myvars,
  ...
}: let
  hostName = "goudan";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  # Keep it as close to the generated defaults as possible.
  networking = {
    inherit hostName;
    # NetworkManager manages DHCP; avoid conflict with networking.useDHCP
    networkmanager.enable = true;
  };

  # Conservative kernel choice to improve stability
  boot.kernelPackages =
    if pkgs ? linuxPackages_6_6
    then pkgs.linuxPackages_6_6
    else pkgs.linuxPackages_latest;

  # UEFI boot via systemd-boot
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    systemd-boot.enable = true;
  };

  # Basic remote management
  services.openssh.enable = true;

  # Do not manage users here; keep existing accounts as-is
  users.mutableUsers = true;

  system.stateVersion = "25.05";
}
