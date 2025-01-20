{
  pkgs,
  lib,
  username,
  ...
}: {


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    home = "/home/${username}";  # 指定家目录路径
    createHome = true;  # 自动创建家目录
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDahtg4XowKbLXvjg60Z3iezvP8SDMJV5K0ufbOCGZLRsaxNZg9yPEprk2YWWUTDeq5z0reFCNET0tyyt/3AN9L06FmWq1dn7uGTOt6XBlEBwZ5ajyHULbbDDArOcl9MAU7bcqlZ2L0i2YEwzbcNLWv7bfVPVETMG5neqzvYz53Bz6IVSkd2stbhlROKxABovG+JAyqGqZjDSjYd6KHwbE28rjQnjA7psb8qQfRQAa8mx8WlZLB1vUnG79G+wSUwXXquJYHNZkMZjAgnfz5PLQrRM06u01P8pR57JQqObJIRjrmKAfaxVnNEusS9kMYoi2u+jghc3z625i8xEADfgIhCIchDDs+7kSR+RdJ0fbO75vLSZjjAwE4bCMEmJelcVGCnaEv83rjL0G8hEcf1V7HLDrKdaiqQ0PIInmU7iqdb7t5GixQFCmJqk6c/AvN+RTxk7TbyTDctTu8lgIaAFWdHF9TZSnbXzhbrGYLux5c9v5amLn6xWb4C8UZ5Ou1GDs= wicsp@macsp"
    ];
  };

  security.sudo.wheelNeedsPassword = true;

  # customise /etc/nix/nix.conf declaratively via `nix.settings`
  nix.settings = {
    trusted-users = [username];
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://hyprland.cachix.org"
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    builders-use-substitutes = true;
  };

  nix.package = pkgs.nix;
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };






  environment.systemPackages = with pkgs; [
    vim 
    wget
    curl
    git
    neofetch
  ];





}
