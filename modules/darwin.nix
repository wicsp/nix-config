  {
  pkgs,
  lib,
  username,
  ...
}:{
  # Auto upgrade nix package and the daemon service.
        #  - The option definition `services.nix-daemon.enable' in `/nix/store/z8gh3fxpds3aq7nj6cvq6jpy2kvchqv9-source/modules/darwin.nix' no longer has any effect; please remove it.
      #  nix-darwin now manages nix-daemon unconditionally when
      #  `nix.enable` is on.
  # services.nix-daemon.enable = true;
  nix.enable = true;

  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
users.users.${username} = {
    description = username;
    home = "/Users/${username}";  # 指定家目录路径
  }; 

  homebrew = {
    enable = false;

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