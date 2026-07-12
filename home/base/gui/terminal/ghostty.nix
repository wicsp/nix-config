{
  lib,
  pkgs,
  ...
}:
###########################################################
#
# Ghostty Configuration
#
###########################################################
let
  settings = {
    font-family = "Maple Mono NF CN";
    font-size = 13;
    window-decoration = "none";

    background-opacity = 0.93;
    # only supported on macOS;
    background-blur-radius = 10;
    scrollback-limit = 20000;

    # https://ghostty.org/docs/config/reference#command
    #  To resolve issues:
    #    1. https://github.com/ryan4yin/nix-config/issues/26
    #    2. https://github.com/ryan4yin/nix-config/issues/8
    command = "${pkgs.bash}/bin/bash --login -i";
  };

  darwinConfig = ''
    font-family = Maple Mono NF CN
    font-size = 13
    window-decoration = none
    background-opacity = 0.93
    background-blur-radius = 10
    scrollback-limit = 20000
    command = ${pkgs.bash}/bin/bash --login -i
  '';
in
{
  programs.ghostty = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    package = pkgs.ghostty; # the stable version
    # package = ghostty.packages.${pkgs.system}.default; # the latest version
    enableBashIntegration = false;
    installBatSyntax = false;
    # installVimSyntax = true;
    inherit settings;
  };

  xdg.configFile."ghostty/config" = lib.mkIf pkgs.stdenv.isDarwin {
    text = darwinConfig;
  };
}
