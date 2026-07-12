{ pkgs, ... }:
{
  # terminal file manager
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    shellWrapperName = "y";
    # Changing working directory when exiting Yazi
    enableBashIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };
  };
}
