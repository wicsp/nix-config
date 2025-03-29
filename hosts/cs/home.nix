{
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/home-manager/base.nix  # 基础用户配置
  ];

  # 家目录配置
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    # 常用包
    packages = with pkgs; [
      ripgrep
      fd
      fzf
      jq
      tree
      neofetch
      btop
    ];
  };

  # 启用家目录管理
  programs = {
    home-manager.enable = true;

    # Git 配置
    git = {
      enable = true;
      userName = username;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    # Fish shell 配置
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting  # 禁用欢迎消息
      '';
    };

    # Tmux 配置
    tmux = {
      enable = true;
      shortcut = "a";
      terminal = "screen-256color";
      historyLimit = 10000;
    };
  };

  # 文件配置
  home.file = {
    ".config/fish/functions/fish_prompt.fish".text = ''
      function fish_prompt
        set -l last_status $status
        set -l normal (set_color normal)
        set -l status_color (set_color brgreen)
        set -l cwd_color (set_color blue)
        set -l vcs_color (set_color purple)
        
        # 显示用户名和主机名
        echo -n (set_color yellow)$USER(set_color white)@(set_color green)(prompt_hostname)
        
        # 显示当前目录
        echo -n ' '$cwd_color(prompt_pwd)
        
        # Git 状态
        set -l git_status (fish_git_prompt)
        if test -n "$git_status"
          echo -n $vcs_color$git_status
        end
        
        # 新行和提示符
        echo
        if test $last_status -eq 0
          echo -n $status_color'❯ '$normal
        else
          echo -n (set_color red)'❯ '$normal
        end
      end
    '';
  };
}