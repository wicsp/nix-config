{myvars, ...}:
#############################################################
#
#  Goudan - TUI/Server-like (matches mio)
#
#############################################################
let
  hostName = "goudan"; # Define your hostname.
in {
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

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  # Enable tailscale
  services.tailscale.enable = true;

  # X11 configuration is handled by modules/nixos/desktop.nix
  # based on wayland/xorg enable options
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
