{
  # enable the node exporter on all nixos hosts
  # https://githcurl -X DELETE http://localhost:56155/metrics/job/my_job/a/9nix-shell -p nix-info --run "nix search nixpkgs prometheus_client"ub.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/monitoring/prometheus/exporters/node.nix
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 9100;
    # There're already a lot of collectors enabled by default
    # https://github.com/prometheus/node_exporter?tab=readme-ov-file#enabled-by-default
    enabledCollectors = [
      "systemd"
      "logind"
    ];

    # use either enabledCollectors or disabledCollectors
    # disabledCollectors = [];
  };
}
