{config, pkgs, ...}:{
  programs.kitty = {
    enable = true; # required for the default Hyprland config
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
      cursor_blink_interval  = "0";
      # https://www.bilibili.com
      detect_urls = true;
      mouse_hide_wait  = "0.5";
      cursor_trail ="3";  # Neovide Like Cursor

      #other settings
      enable_audio_bell = false;
      macos_option_as_alt = true; # Option key acts as Alt on macOS
      disable_ligatures  = "cursor"; # disable ligatures for cursor

      #  To resolve issues:
      #    1. https://github.com/ryan4yin/nix-config/issues/26
      #    2. https://github.com/ryan4yin/nix-config/issues/8
      #  Spawn a nushell in login mode via `bash`s
      
    };
    extraConfig = 
"bold_font            Maple Mono NF CN Bold
italic_font          Maple Mono NF CN Italic
bold_italic_font     Maple Mono NF CN Bold Italic
font_features        MapleMono-NF-CN-ExtraLight +zero
font_features        MapleMono-NF-CN-Bold +zero
font_features        MapleMono-NF-CN-Italic +zero
font_features        MapleMono-NF-CN-BoldItalic +zero

# vim key mapping
map cmd+s send_text all \e:w\r
map cmd+p send_text all :Telescope find_files\r
map cmd+shift+f send_text all :Telescope live_grep\r
map cmd+b send_text all :Neotree toggle\r


# tmux key mapping
map cmd+1 combine : send_key ctrl+a : send_key 1
map cmd+2 combine : send_key ctrl+a : send_key 2
map cmd+3 combine : send_key ctrl+a : send_key 3
map cmd+4 combine : send_key ctrl+a : send_key 4
map cmd+5 combine : send_key ctrl+a : send_key 5
map cmd+6 combine : send_key ctrl+a : send_key 6
map cmd+7 combine : send_key ctrl+a : send_key 7
map cmd+8 combine : send_key ctrl+a : send_key 8
map cmd+9 combine : send_key ctrl+a : send_key 9";
    # macOS specific settings
    darwinLaunchOptions = ["--start-as=maximized"];
  };
}