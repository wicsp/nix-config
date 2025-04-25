{pkgs, ...}: {
  # Enable Home Manager to manage user Systemd services
  systemd.user.enable = true;

  # Configure user Systemd service manager settings
  systemd.user.settings = {
    Manager = {
      DefaultTimeoutStartSec = "30s"; # Timeout for service start
      DefaultRestartSec = "5s"; # Delay before restarting
    };
  };

  # Set service start timeout (e.g., for slow-starting services)
  systemd.user.servicesStartTimeoutMs = 60000; # 60 seconds

  # Automatically start/stop services during home-manager switch
  systemd.user.startServices = "sd-switch";

  # Define a per-user service for n8n
  systemd.user.services.n8n = {
    description = "n8n Workflow Automation Tool";
    wantedBy = ["default.target"]; # Start with user session
    serviceConfig = {
      ExecStart = "${pkgs.nodePackages.n8n}/bin/n8n";
      Restart = "always"; # Restart on failure
      RestartSec = 5; # Wait 5 seconds before restarting (int, not string)
      Environment = [
        "NODE_ENV=production"
        "N8N_PORT=5678" # Use N8N_PORT instead of PORT for n8n
      ];
    };
  };

  # Ensure n8n is installed
  home.packages = [pkgs.nodePackages.n8n];
}
