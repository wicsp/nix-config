{
  lib,
  myvars,
  ...
}: {
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = lib.mkDefault false;
  networking.firewall.allowedTCPPorts = [4922];
  programs.ssh = myvars.networking.ssh;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      # root user is used for remote deployment, so we need to allow it
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true; # disable password login
      Port = 4922;
    };
    openFirewall = true;
  };

  # Add terminfo database of all known terminals to the system profile.
  # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/config/terminfo.nix
  environment.enableAllTerminfo = true;
}
