{
  # Enable Home Manager to manage user Systemd services
  systemd.user = {
    enable = true;

    # Configure user Systemd service manager settings
    settings = {
      Manager = {
        DefaultTimeoutStartSec = "30s";
        DefaultRestartSec = "5s";
      };
    };

    # Set service start timeout (e.g., for slow-starting services)
    servicesStartTimeoutMs = 60000; # 60 seconds

    # Automatically start/stop services during home-manager switch
    startServices = "sd-switch";

    # Define the n8n service using the explicit Unit/Service/Install structure
    services.n8n = {
      # Corresponds to [Unit] section
      Unit = {
        Description = "n8n Workflow Automation Tool";
        # Add other [Unit] options here if needed, e.g., After=network.target
      };
      # Corresponds to [Service] section
      Service = {
        ExecStart = "~/.nix-profile/bin/npx n8n";
        Restart = "always";
        RestartSec = "5s"; # Using "5s" is generally preferred for clarity
        Environment = [
          "NODE_ENV=production"
          "PORT=5678"
        ];
        # Add other [Service] options here if needed
      };
      # Corresponds to [Install] section
      Install = {
        WantedBy = [ "default.target" ]; # Start with user session
      };
    };
  };
}
