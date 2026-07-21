{ myvars, ... }:
{
  ####################################################################
  #
  #  NixOS's Configuration for Remote Building / Distributed Building
  #
  #  Related Docs:
  #    1. https://github.com/NixOS/nix/issues/7380
  #    2. https://nixos.wiki/wiki/Distributed_build
  #    3. https://github.com/NixOS/nix/issues/2589
  #
  ####################################################################

  # set local's max-job to 0 to force remote building(disable local building)
  # nix.settings.max-jobs = 0;
  nix = {
    distributedBuilds = true;
    buildMachines =
      let
        sshUser = myvars.username;
        # ssh key's path on local machine
        sshKey = "/etc/agenix/ssh-key-nix-remote-builder"; # dedicated key for nix remote builds (no passphrase)
        systems = [
          # native arch
          "x86_64-linux"

          # emulated arch using binfmt_misc and qemu-user
          "aarch64-linux"
          "riscv64-linux"
        ];
        # all available system features are poorly documentd here:
        #  https://github.com/NixOS/nix/blob/e503ead/src/libstore/globals.hh#L673-L687
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
        ];
      in
      [
        # Nix seems always try to build on the machine remotely
        # to make use of the local machine's high-performance CPU, do not set remote builder's maxJobs too high.
        {
          inherit
            sshUser
            sshKey
            systems
            supportedFeatures
            ;
          hostName = "amax";
          maxJobs = 4; # adjust based on amax's actual CPU core count
          speedFactor = 2;
        }
      ];
    # optional, useful when the builder has a faster internet connection than yours
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
