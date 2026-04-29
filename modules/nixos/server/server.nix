_: {
  # Keep server hosts small by default. Add Docker, btrbk, remote builders,
  # and app services from the host that actually needs them.
  imports = [
    ../base/core.nix
    ../base/i18n.nix
    ../base/monitoring.nix
    ../base/nix.nix
    ../base/ssh.nix
    ../base/user-group.nix
    ../base/zram.nix

    ../../base/nix.nix
    ../../base/overlays.nix
    ../../base/security.nix
    ../../base/users.nix

    ./packages.nix
  ];

  networking.firewall.enable = true;
  environment.enableAllTerminfo = false;
}
