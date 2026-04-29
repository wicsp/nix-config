{
  imports = [
    ../../modules/nixos/server/hysteria.nix
  ];

  modules.server.hysteria = {
    enable = true;
    serverName = "falcon.wicsp.top";
  };
}
