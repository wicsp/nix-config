{pkgs, ...}: {
  # Linux Only Packages, not available on Darwin
  home.packages = with pkgs; [
    # misc
    libnotify
    wireguard-tools # manage wireguard vpn manually, via wg-quick

    tailscale # connect to tailscale network
    # ventoy # create bootable usb
    virt-viewer # vnc connect to VM, used by kubevirt
    vim
  ];

  # auto mount usb drives
  services = {
    udiskie.enable = true;
    # syncthing.enable = true;
  };
}
