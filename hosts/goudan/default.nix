{myvars, ...}:
#############################################################
#
#  Goudan - NixOS Desktop System
#
#############################################################
let
  hostName = "goudan"; # Define your hostname.
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use a more conservative(LTS) kernel than hardware-configuration's latest
  boot.kernelPackages = pkgs.linuxPackages_lts;

  # Boot loader configuration for Windows + Linux dual boot
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev"; # For EFI systems
      useOSProber = true; # 自动检测 Windows
    };
  };

  networking = {
    inherit hostName;
    # inherit (myvars.networking) defaultGateway nameservers;
    # inherit (myvars.networking.hostsInterface.${hostName}) interfaces;

    # desktop need its cli for status bar
    networkmanager.enable = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Firmware & microcode
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  # System-wide Nix daemon settings (silence untrusted substituter warnings, enable flakes)
  nix.settings = {
    trusted-users = ["root" "wicsp"];
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      # Mirrors first, then the official cache
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      # Additional caches used by this flake
      "https://anyrun.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
