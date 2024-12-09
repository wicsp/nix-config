{username, ...}: {
  # import sub modules
  imports = [
    # ./shell.nix
    ./core.nix
    # ./git.nix
    # ./starship.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
