{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.server.hysteria;

  authCommand = pkgs.writeShellScript "hysteria-auth" ''
    set -eu

    expected="$(${pkgs.coreutils}/bin/cat /var/lib/hysteria/auth)"

    if [ "$#" -ge 2 ] && [ "$2" = "$expected" ]; then
      echo "default"
      exit 0
    fi

    exit 1
  '';

  serverConfig = pkgs.writeText "hysteria-server.yaml" ''
    listen: :${toString cfg.port}

    tls:
      cert: /var/lib/hysteria/server.crt
      key: /var/lib/hysteria/server.key
      sniGuard: disable

    auth:
      type: command
      command: ${authCommand}

    masquerade:
      type: proxy
      proxy:
        url: ${cfg.masquerade.url}
        rewriteHost: ${lib.boolToString cfg.masquerade.rewriteHost}
  '';
in
{
  options.modules.server.hysteria = {
    enable = lib.mkEnableOption "Hysteria 2 proxy server";

    port = lib.mkOption {
      type = lib.types.port;
      default = 443;
      description = "UDP port for the Hysteria server.";
    };

    serverName = lib.mkOption {
      type = lib.types.str;
      default = "${config.networking.hostName}.wicsp.top";
      description = "Name written into the generated self-signed certificate.";
    };

    masquerade = {
      url = lib.mkOption {
        type = lib.types.str;
        default = "https://www.cloudflare.com";
        description = "URL used by Hysteria's HTTP masquerade proxy.";
      };

      rewriteHost = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether Hysteria rewrites the masquerade Host header.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.hysteria
    ];

    users.groups.hysteria = { };
    users.users.hysteria = {
      isSystemUser = true;
      group = "hysteria";
    };

    networking.firewall.allowedUDPPorts = [
      cfg.port
    ];

    systemd.services.hysteria-server = {
      description = "Hysteria 2 proxy server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        set -eu
        umask 077

        if [ ! -s /var/lib/hysteria/auth ]; then
          ${pkgs.openssl}/bin/openssl rand -base64 32 > /var/lib/hysteria/auth
        fi

        if [ ! -s /var/lib/hysteria/server.crt ] || [ ! -s /var/lib/hysteria/server.key ]; then
          ${pkgs.coreutils}/bin/rm -f /var/lib/hysteria/server.crt /var/lib/hysteria/server.key
          ${pkgs.openssl}/bin/openssl ecparam -genkey -name prime256v1 -out /var/lib/hysteria/server.key
          ${pkgs.openssl}/bin/openssl req -new -x509 -sha256 \
            -key /var/lib/hysteria/server.key \
            -out /var/lib/hysteria/server.crt \
            -days 3650 \
            -subj "/CN=${cfg.serverName}" \
            -addext "subjectAltName=DNS:${cfg.serverName}"
        fi
      '';

      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.hysteria} server --config ${serverConfig}";
        User = "hysteria";
        Group = "hysteria";
        StateDirectory = "hysteria";
        StateDirectoryMode = "0700";
        UMask = "0077";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = [ "/var/lib/hysteria" ];
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };
}
