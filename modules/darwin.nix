  {
  pkgs,
  lib,
  ...
}:{  
   nix.gc = {
    automatic = lib.mkDefault true;
    interval = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  }; 
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = false;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;


  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      # cleanup = "zap";
    };

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      # "aria2"  # download tool
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      # "google-chrome"
    ];
  };

}