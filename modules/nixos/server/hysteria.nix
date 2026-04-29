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

    acme:
      domains:
        - ${cfg.serverName}
      email: ${cfg.acme.email}
      ca: ${cfg.acme.ca}
      dir: /var/lib/hysteria/acme
      type: tls
      tls: {}

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
      description = "Domain name used by clients and ACME certificates.";
    };

    acme = {
      email = lib.mkOption {
        type = lib.types.str;
        default = "wicspa@gmail.com";
        description = "Email address used for ACME registration.";
      };

      ca = lib.mkOption {
        type = lib.types.enum [
          "letsencrypt"
          "zerossl"
        ];
        default = "letsencrypt";
        description = "ACME CA used to issue the Hysteria certificate.";
      };
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

    networking.firewall.allowedTCPPorts = [
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
