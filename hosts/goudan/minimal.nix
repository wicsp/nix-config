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
    useDHCP = true;
    networkmanager.enable = true;
  };

  # Conservative kernel choice to improve stability
  boot.kernelPackages = pkgs.linuxPackages_lts;

  # Basic remote management
  services.openssh.enable = true;

  # Do not manage users here; keep existing accounts as-is
  users.mutableUsers = true;

  system.stateVersion = "25.05";
}
