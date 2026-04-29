{ myvars, ... }:
{
  imports = [
    ../base/home.nix
    ../base/tui/ssh.nix
    ./base/shell.nix
  ];

  home.homeDirectory = "/home/${myvars.username}";

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.nushell.enable = true;
}
