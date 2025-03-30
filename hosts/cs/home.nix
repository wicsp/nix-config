{ config, pkgs, username, ... }:
{

  imports = [
    ../../home
  ];

  # 家目录配置
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };
  programs.home-manager.enable = true;
}