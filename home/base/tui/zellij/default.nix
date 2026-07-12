{ pkgs, ... }:
let
  shellAliases = {
    "zj" = "zellij";
  };
in
{
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
  };
  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
  # Disable catppuccin to avoid conflict with my non-nix config.
  catppuccin.zellij.enable = false;

  programs.bash.bashrcExtra = ''
    # auto start zellij
    # except when in emacs or zellij itself
    if [[ -z "''${ZELLIJ:-}" && -z "''${INSIDE_EMACS:-}" ]]; then
      if [[ "''${ZELLIJ_AUTO_ATTACH:-}" == "true" ]]; then
        zellij attach -c
      else
        zellij
      fi

      # Auto exit the shell session when zellij exit
      export ZELLIJ_AUTO_EXIT="false" # disable auto exit
      if [[ "''${ZELLIJ_AUTO_EXIT:-}" == "true" ]]; then
        exit
      fi
    fi
  '';

  home.shellAliases = shellAliases;
}
