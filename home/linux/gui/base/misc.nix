{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # GUI apps
    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf
    foliate

    # instant messaging
    telegram-desktop
    # discord # update too frequently, use the web version instead

    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    # misc
    flameshot
    # ventoy # multi-boot usb creator

    # my custom hardened packages
    # pkgs.nixpaks.qq  # temporarily disabled due to nixpaks missing
    # pkgs.nixpaks.qq-desktop-item  # temporarily disabled due to nixpaks missing

    wechat-uos
    # pkgs.nixpaks.wechat-uos
    # pkgs.nixpaks.wechat-uos-desktop-item
  ];

  # GitHub CLI tool
  programs.gh = {
    enable = true;
  };

  # allow fontconfig to discover fonts and configurations installed through home.packages
  # Install fonts at system-level, not user-level
  fonts.fontconfig.enable = false;
}
