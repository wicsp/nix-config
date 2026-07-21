{
  config,
  lib,
  pkgs,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  configDir = "${homeDir}/.config";
  dataDir = "${homeDir}/.local/share";
  prometheusPort = 9091;
  grafanaPort = 3000;

  prometheusConfigPath = "${configDir}/prometheus/prometheus.yml";
  prometheusDataDir = "${dataDir}/prometheus";

  grafanaConfigPath = "${configDir}/grafana/grafana.ini";
  grafanaProvisioningDir = "${configDir}/grafana/provisioning";
  grafanaDataDir = "${dataDir}/grafana";
in
{
  systemd.user = {
    enable = true;
    settings = {
      Manager = {
        DefaultTimeoutStartSec = "30s";
        DefaultRestartSec = "5s";
      };
    };
    servicesStartTimeoutMs = 60000;
    startServices = "sd-switch";
    services = {
      prometheus = {
        Unit = {
          Description = "Prometheus";
          After = [ "network.target" ];
        };
        Service = {
          ExecStart = lib.concatStringsSep " " [
            "${pkgs.prometheus}/bin/prometheus"
            "--config.file=${prometheusConfigPath}"
            "--storage.tsdb.path=${prometheusDataDir}"
            "--storage.tsdb.retention.time=15d"
            "--web.listen-address=127.0.0.1:${toString prometheusPort}"
          ];
          Restart = "always";
          RestartSec = "5s";
          WorkingDirectory = prometheusDataDir;
        };
        Install.WantedBy = [ "default.target" ];
      };
      grafana = {
        Unit = {
          Description = "Grafana";
          After = [
            "network.target"
            "prometheus.service"
          ];
          Wants = [ "prometheus.service" ];
        };
        Service = {
          Environment = [
            "GF_PATHS_HOME=${pkgs.grafana}/share/grafana"
            "GF_PATHS_CONFIG=${grafanaConfigPath}"
            "GF_PATHS_DATA=${grafanaDataDir}"
            "GF_PATHS_LOGS=${grafanaDataDir}/log"
            "GF_PATHS_PLUGINS=${grafanaDataDir}/plugins"
            "GF_PATHS_PROVISIONING=${grafanaProvisioningDir}"
          ];
          ExecStart = "${pkgs.grafana}/bin/grafana-server -homepath ${pkgs.grafana}/share/grafana -config ${grafanaConfigPath}";
          Restart = "always";
          RestartSec = "5s";
          WorkingDirectory = grafanaDataDir;
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };

  home = {
    activation.monitoringDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${configDir}/prometheus"
      mkdir -p "${grafanaProvisioningDir}/datasources"
      mkdir -p "${grafanaDataDir}" "${grafanaDataDir}/log" "${grafanaDataDir}/plugins"
      mkdir -p "${prometheusDataDir}"
    '';
    file = {
      ".config/prometheus/prometheus.yml".text = ''
        global:
          scrape_interval: 15s
          evaluation_interval: 15s

        scrape_configs:
          - job_name: prometheus
            static_configs:
              - targets:
                  - 127.0.0.1:${toString prometheusPort}

          - job_name: nixos_nodes
            static_configs:
              - targets:
                  - goudan:9100
                  - mio:9100
      '';
      ".config/grafana/grafana.ini".text = ''
        [server]
        http_addr = 0.0.0.0
        http_port = ${toString grafanaPort}

        [users]
        allow_sign_up = false
      '';
      ".config/grafana/provisioning/datasources/prometheus.yaml".text = ''
        apiVersion: 1

        datasources:
          - name: Prometheus
            type: prometheus
            access: proxy
            url: http://127.0.0.1:${toString prometheusPort}
            isDefault: true
            editable: true
      '';
    };
  };
}
