{ ... }:{

  # import sub modules
  imports = [
    # ./shell.nix
    ./core.nix
    # ./git.nix
    # ./starship.nix
  ];
  
  home = {
    homeDirectory = /. + builtins.getEnv("HOME");
    stateVersion = "24.05";
  };


  programs.home-manager.enable = true;
}