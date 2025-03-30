{config, pkgs, ...}:{
  programs.thefuck = {
    enable = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };
}