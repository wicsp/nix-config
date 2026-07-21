{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./anyrun.nix
    ./nvidia.nix
    ../noctalia
  ];

  config = lib.mkMerge [
    {
      # wayland related
      home.sessionVariables = {
        "NIXOS_OZONE_WL" = "1";
        "MOZ_ENABLE_WAYLAND" = "1";
        "MOZ_WEBRENDER" = "1";
        "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
        "_JAVA_AWT_WM_NONREPARENTING" = "1";
        "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
        "QT_QPA_PLATFORM" = lib.mkDefault "wayland";
        "SDL_VIDEODRIVER" = "wayland";
        "GDK_BACKEND" = "wayland";
        "XDG_SESSION_TYPE" = "wayland";
      };

      home.packages = with pkgs; [
        swaybg
        wl-clipboard
        hyprpicker
        brightnessctl
        hyprshot
        wf-recorder
        alsa-utils
        networkmanagerapplet
      ];
    }
    (lib.mkIf (!config.modules.desktop.noctalia.enable) {
      xdg.configFile =
        let
          mkSymlink = config.lib.file.mkOutOfStoreSymlink;
          confPath = "${config.home.homeDirectory}/nix-config/home/linux/gui/base/desktop/conf";
        in
        {
          "mako".source = mkSymlink "${confPath}/mako";
          "waybar".source = mkSymlink "${confPath}/waybar";
          "wlogout".source = mkSymlink "${confPath}/wlogout";
          "hypr/hypridle.conf".source = mkSymlink "${confPath}/hypridle.conf";
        };

      programs = {
        waybar = {
          enable = true;
          systemd.enable = true;
        };
        swaylock.enable = true;
        wlogout.enable = true;
      };

      services = {
        hypridle.enable = true;
        mako.enable = true;
      };

      catppuccin = {
        waybar.enable = false;
        swaylock.enable = false;
        wlogout.enable = false;
        mako.enable = false;
      };
    })
  ];
}
