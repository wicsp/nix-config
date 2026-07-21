{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.noctalia;
in
{
  options.modules.desktop.noctalia.enable = lib.mkEnableOption "Noctalia desktop shell";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      noctalia-shell
      app2unit
      cliphist
      qt6Packages.qt6ct
    ];

    # Noctalia owns the bar, launcher, notifications, lock screen, OSD, and
    # session menu. Its settings remain mutable through the UI and are
    # persisted by the goudan preservation manifest.
    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };

    xdg.configFile."qt6ct/qt6ct.conf".text = ''
      [Appearance]
      icon_theme=Papirus-Dark
      standard_dialogs=xdgdesktopportal

      [Fonts]
      fixed="Maple Mono NF CN,11,-1,5,50,0,0,0,0,0"
      general="Source Sans 3,11,-1,5,50,0,0,0,0,0"

      [Interface]
      stylesheets=@Invalid()
    '';
  };
}
