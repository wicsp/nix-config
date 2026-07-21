{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot = {
    loader = {
      efi.efiSysMountPoint = "/boot/efi";
      grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };
    };
    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "xen_blkfront"
      "vmw_pvscsi"
    ];
    initrd.kernelModules = [ "nvme" ];
  };
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/D1D1-9C4E";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/vda3";
    fsType = "ext4";
  };

}
