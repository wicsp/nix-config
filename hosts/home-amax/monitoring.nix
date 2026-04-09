{ config, lib, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  configDir = "${homeDir}/.config";
  dataDir = "${homeDir}/.local/share";
  nodeExporterPort = 9100;
  prometheusPort = 9091;
  grafanaPort = 3000;

  prometheusConfigPath = "${configDir}/prometheus/prometheus.yml";
  prometheusDataDir = "${dataDir}/prometheus";

  grafanaConfigPath = "${configDir}/grafana/grafana.ini";
  grafanaProvisioningDir = "${configDir}/grafana/provisioning";
  grafanaDataDir = "${dataDir}/grafana";
in
{
  systemd.user.enable = true;
  systemd.user.settings = {
    Manager = {
      DefaultTimeoutStartSec = "30s";
      DefaultRestartSec = "5s";
    };
  };
  systemd.user.servicesStartTimeoutMs = 60000;
  systemd.user.startServices = "sd-switch";

  home.activation.monitoringDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${configDir}/prometheus"
    mkdir -p "${grafanaProvisioningDir}/datasources"
    mkdir -p "${grafanaDataDir}" "${grafanaDataDir}/log" "${grafanaDataDir}/plugins"
    mkdir -p "${prometheusDataDir}"
  '';

  home.file.".config/prometheus/prometheus.yml".text = ''
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
              - 127.0.0.1:${toString nodeExporterPort}
              - goudan:9100
              - falcon:9100
  '';

  home.file.".config/grafana/grafana.ini".text = ''
    [server]
    http_addr = 0.0.0.0
    http_port = ${toString grafanaPort}

    [users]
    allow_sign_up = false
  '';

  home.file.".config/grafana/provisioning/datasources/prometheus.yaml".text = ''
    apiVersion: 1

    datasources:
      - name: Prometheus
        type: prometheus
        access: proxy
        url: http://127.0.0.1:${toString prometheusPort}
        isDefault: true
        editable: true
  '';

  systemd.user.services.prometheus = {
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
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.node-exporter = {
    Unit = {
      Description = "Prometheus Node Exporter";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = lib.concatStringsSep " " [
        "${pkgs.prometheus-node-exporter}/bin/node_exporter"
        "--web.listen-address=127.0.0.1:${toString nodeExporterPort}"
      ];
      Restart = "always";
      RestartSec = "5s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.grafana = {
    Unit = {
      Description = "Grafana";
      After = [
        "network.target"
        "node-exporter.service"
        "prometheus.service"
      ];
      Wants = [
        "node-exporter.service"
        "prometheus.service"
      ];
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
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
