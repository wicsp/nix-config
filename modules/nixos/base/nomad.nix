{

  services.nomad = {
    enable = true;
    dropPrivileges = false;

  };

  systemd.services.nomad = {
    wants = [
      "network-online.target"
      "tailscaled.service"
    ];
    after = [
      "network-online.target"
      "tailscaled.service"
    ];
  };
}
