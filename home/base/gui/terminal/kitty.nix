{
  lib,
  pkgs,
  ...
}:
###########################################################
#
# Kitty Configuration
#
# Useful Hot Keys for Linux(replace `ctrl + shift` with `cmd` on macOS)):
#   1. Increase Font Size: `ctrl + shift + =` | `ctrl + shift + +`
#   2. Decrease Font Size: `ctrl + shift + -` | `ctrl + shift + _`
#   3. And Other common shortcuts such as Copy, Paste, Cursor Move, etc.
#
###########################################################
{
  programs.kitty = {
    enable = true;
    # kitty has catppuccin theme built-in,
    # all the built-in themes are packaged into an extra package named `kitty-themes`
    # and it's installed by home-manager if `theme` is specified.
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "Maple Mono NF CN ExtraLight";
      # use different font size on macOS
      size =
        if pkgs.stdenv.isDarwin
        then 14
        else 13;
    };

    # consistent with other terminal emulators
    keybindings = {
      "ctrl+shift+m" = "toggle_maximized";
      "ctrl+shift+f" = "show_scrollback"; # search in the current window
    };

    settings = {
      # window settings
      hide_window_decorations = "titlebar-only"; # show window decorations
      window_padding_width = "0";
      background_opacity = "0.93";
      background_blur = "64";
      remember_window_size = true;

      # tab bar settings
      tab_bar_edge = "top"; # tab bar on top
      tab_bar_style = "powerline"; # normal tab bar style powerline
      tab_powerline_style = "slanted"; # sharp powerline style

      # cursor settings
      cursor_blink_interval = "0";
      # https://www.bilibili.com
      detect_urls = true;
      mouse_hide_wait = "0.5";
      cursor_trail = "5"; # Neovide Like Cursor
      disable_ligatures = "cursor"; # disable ligatures for cursor

      #other settings
      # enabled_layouts = "tall stack full";
      macos_option_as_alt = true; # Option key acts as Alt on macOS
      enable_audio_bell = false;
      #  To resolve issues:
      #    1. https://github.com/ryan4yin/nix-config/issues/26
      #    2. https://github.com/ryan4yin/nix-config/issues/8
      #  Spawn a nushell in login mode via `bash`
      shell = "${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'";
    };

    extraConfig = "bold_font            Maple Mono NF CN Bold
italic_font          Maple Mono NF CN Italic
bold_italic_font     Maple Mono NF CN Bold Italic
font_features        MapleMono-NF-CN-ExtraLight +zero
font_features        MapleMono-NF-CN-Bold +zero
font_features        MapleMono-NF-CN-Italic +zero
font_features        MapleMono-NF-CN-BoldItalic +zero
";

    # macOS specific settings
    darwinLaunchOptions = ["--start-as=maximized"];
  };
}
