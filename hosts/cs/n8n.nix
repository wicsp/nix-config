{
  # Enable Home Manager to manage user Systemd services
  systemd.user.enable = true;

  # Configure user Systemd service manager settings
  systemd.user.settings = {
    Manager = {
      DefaultTimeoutStartSec = "30s";
      DefaultRestartSec = "5s";
    };
  };

  # Set service start timeout (e.g., for slow-starting services)
  systemd.user.servicesStartTimeoutMs = 60000; # 60 seconds

  # Automatically start/stop services during home-manager switch
  systemd.user.startServices = "sd-switch";

  # Define a per-user service for a Node.js app
  systemd.user.services.n8n = {
    description = "n8n";
    wantedBy = ["default.target"]; # Start with user session
    serviceConfig = {
      ExecStart = "~/.nix-profile/bin/npx n8n";
      Restart = "always"; # Restart on failure
      RestartSec = "5"; # Wait 5 seconds before restarting
      Environment = [
        "NODE_ENV=production"
        "PORT=5678"
      ];
    };
  };
}
