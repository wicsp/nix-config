{
  pkgs,
  lib,
  username,
  ...
}:{ 

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.${username} = {
        isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    description = username;
    home = "/home/${username}";  # 指定家目录路径
    createHome = true;  # 自动创建家目录
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDahtg4XowKbLXvjg60Z3iezvP8SDMJV5K0ufbOCGZLRsaxNZg9yPEprk2YWWUTDeq5z0reFCNET0tyyt/3AN9L06FmWq1dn7uGTOt6XBlEBwZ5ajyHULbbDDArOcl9MAU7bcqlZ2L0i2YEwzbcNLWv7bfVPVETMG5neqzvYz53Bz6IVSkd2stbhlROKxABovG+JAyqGqZjDSjYd6KHwbE28rjQnjA7psb8qQfRQAa8mx8WlZLB1vUnG79G+wSUwXXquJYHNZkMZjAgnfz5PLQrRM06u01P8pR57JQqObJIRjrmKAfaxVnNEusS9kMYoi2u+jghc3z625i8xEADfgIhCIchDDs+7kSR+RdJ0fbO75vLSZjjAwE4bCMEmJelcVGCnaEv83rjL0G8hEcf1V7HLDrKdaiqQ0PIInmU7iqdb7t5GixQFCmJqk6c/AvN+RTxk7TbyTDctTu8lgIaAFWdHF9TZSnbXzhbrGYLux5c9v5amLn6xWb4C8UZ5Ou1GDs= wicsp@macsp"
    ];
  }; 

  security.sudo.wheelNeedsPassword = true;
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


}