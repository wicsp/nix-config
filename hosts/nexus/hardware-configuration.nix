{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot = {
    loader.grub.device = "/dev/vda";
    tmp.cleanOnBoot = true;
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "xen_blkfront"
        "vmw_pvscsi"
      ];
      kernelModules = [ "nvme" ];
    };
  };
  fileSystems."/" = {
    # Image formats such as KubeVirt provide their own labelled root device.
    device = lib.mkDefault "/dev/vda1";
    fsType = "ext4";
  };
}
