{
  # Server-specific home configuration for mio
  # Minimal TUI tools and development environment

  # Enable tmux for server management
  programs.tmux = {
    enable = true;
    keyMode = "vi";
  };

  # Enable htop for system monitoring
  programs.htop = {
    enable = true;
  };
}
