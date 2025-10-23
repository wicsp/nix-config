{
  modules.desktop = {
    hyprland = {
      enable = true;
      settings = {
        # Configure your Display resolution, offset, scale and Monitors here, use `hyprctl monitors` to get the info.
        #   highres:      get the best possible resolution
        #   auto:         position automatically
        #   1.0:          scale to 1.0 times (no scaling)
        monitor = "DP-1,highres,auto,1.0";
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
          IdentityFile ~/.ssh/goudan
          # Specifies that ssh should only use the identity file explicitly configured above
          # required to prevent sending default identity files first.
          IdentitiesOnly yes
    '';
  };
}
