{config, pkgs, ...}:{ 
    
  home.packages = with pkgs;[
    atuin
    nushell
    # 如下是我常用的一些命令行工具，你可以根据自己的需要进行增删
    # archives
    zip
    unzip
    # p7zip
    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    fastfetch
    cowsay
    file
    which
    tree    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    # nix-output-monitor
    glow # markdown previewer in terminal

    btop 
    lsof 
  ];
  programs = {


    ssh = {
      enable = true; 

    };

      # git 相关配置
    git = {
      enable = true;
      userName = "wicsp";
      userEmail = "wicspa@gmail.com";
      lfs.enable = true;
      extraConfig = {
      core = {
          quotepath = false;
        };
        pull = {
          rebase = false;
        };
      };
      ignores = [
        ".DS_Store"
      ];
    };
       # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      enableZshIntegration = true;
    };

    # terminal file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableBashIntegration = true;
    };

      # 启用 starship，这是一个漂亮的 shell 提示符
    starship = {
      enable = true;
      # 自定义配置
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
      # TODO 在这里添加你的自定义 bashrc 内容
      # bashrcExtra = ''
      #   export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      # '';

      # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
      shellAliases = {
        nixupdate = "sudo nixos-rebuild switch";
        nixclear = "sudo nix-collect-garbage -d; nix-collect-garbage -d";
      #   k = "kubectl";
      #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      };
    };

  };

}