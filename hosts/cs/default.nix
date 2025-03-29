{
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/nixos/base.nix  # 基础系统配置
  ];

  # 基本系统配置
  networking = {
    hostName = "cs";  # 设置主机名
    networkmanager.enable = true;  # 启用网络管理
  };

  # 系统时区和语言设置
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  # 用户配置
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.fish;  # 使用 fish shell
  };

  # 启用常用服务
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    # 其他服务配置...
  };

  # 系统包
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
    tmux
  ];

  # Docker 配置
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      registry-mirrors = [
        "https://docker.mirrors.ustc.edu.cn"
        "https://mirror.ccs.tencentyun.com"
      ];
    };
  };

  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}