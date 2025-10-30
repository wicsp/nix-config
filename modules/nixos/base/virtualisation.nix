{
  pkgs,
  # nur-ataraxiasjel,
  ...
}:
{
  ###################################################################################
  #
  #  Virtualisation - Libvirt(QEMU/KVM) / Docker / LXD / WayDroid
  #
  ###################################################################################

  # Enable nested virtualization, required by security containers and nested vm.
  # This should be set per host in /hosts, not here.
  #
  ## For AMD CPU, add "kvm-amd" to kernelModules.
  # boot.kernelModules = ["kvm-amd"];
  # boot.extraModprobeConfig = "options kvm_amd nested=1";  # for amd cpu
  #
  ## For Intel CPU, add "kvm-intel" to kernelModules.
  # boot.kernelModules = ["kvm-intel"];
  # boot.extraModprobeConfig = "options kvm_intel nested=1"; # for intel cpu

  boot.kernelModules = [ "vfio-pci" ];

  # Flatpak is mainly for desktop environments, disable on servers
  # services.flatpak.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };

    podman = {
      enable = false;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # Periodically prune Podman resources
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };

    oci-containers = {
      backend = "docker";
    };

    # Usage: https://wiki.nixos.org/wiki/Waydroid
    # waydroid.enable = true;

    # libvirtd = {
    #   enable = true;
    #   # hanging this option to false may cause file permission issues for existing guests.
    #   # To fix these, manually change ownership of affected files in /var/lib/libvirt/qemu to qemu-libvirtd.
    #   qemu.runAsRoot = true;
    # };

    # lxd.enable = true;
  };

  # Only install essential virtualization packages for servers
  # Desktop-specific packages like virt-manager should be in desktop modules
  environment.systemPackages = with pkgs; [
    # QEMU/KVM(HostCpuOnly) - essential for VMs
    qemu_kvm

    # Only include full QEMU if needed for cross-architecture work
    # qemu
  ];
}
