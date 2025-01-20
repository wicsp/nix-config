{
  pkgs,
  lib,
  ...
}:{  
  networking.firewall.allowedTCPPorts = [ 4922 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
      Port = 4922;
    };
    openFirewall = false;
  };

}