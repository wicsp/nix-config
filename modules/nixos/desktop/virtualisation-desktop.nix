{
  pkgs,
  ...
}:
{
  ###################################################################################
  #
  #  Desktop-specific Virtualisation - GUI tools and desktop integrations
  #
  ###################################################################################

  # Enable Flatpak for desktop applications
  services.flatpak.enable = true;

  # Desktop virtualization packages
  environment.systemPackages = with pkgs; [
    # GUI management tools
    # virt-manager  # GUI for libvirt VMs

    # Full QEMU with all architectures for development
    qemu

    # Mobile emulation (Android apps on Linux)
    # nur-ataraxiasjel.packages.${pkgs.system}.waydroid-script
  ];

  # Optionally enable additional desktop virtualization features
  # virtualisation = {
  #   waydroid.enable = true;  # Android app support
  #   libvirtd = {
  #     enable = true;
  #     qemu.runAsRoot = true;
  #   };
  # };
}
