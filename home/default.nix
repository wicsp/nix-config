{ config, pkgs, ... }:
{
  imports =
    [
      ./configs/nvim.nix
      ./common.nix
    ];

  programs = {
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      enableZshIntegration = true;
    };
    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      settings = {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "https://api.atuin.sh";
      };
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
        add_newline = true;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };

    fish = {
      enable = true;
    };

    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/go/bin"
        export PATH="$PATH:/usr/local/bin:/opt/homebrew/bin"

        # Golang
        export PATH=$PATH:/usr/local/go/bin
        export GOPATH=$HOME/Projects/go
        export PATH=$PATH:$GOPATH/bin

        # MacTeX
        export PATH=$PATH:/Library/TeX/texbin

        # pnpm
        export PNPM_HOME="/Users/wicsp/Library/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        # pnpm end

        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

     
        if [ -f /etc/profile.d/clash.sh ]; then 
          source /etc/profile.d/clash.sh
          source /opt/clash/script/common.sh && source /opt/clash/script/clashctl.sh
        fi

        export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
        export BARK_ID="j7kb5DDBxSbMdr44T2qbyS"
        export EDITOR="nvim"

        bind 'set completion-ignore-case on'
        source /etc/agenix/secrets_env

        # if [ -e /home/wicsp/.nix-profile/etc/profile.d/nix.sh ]; then . /home/wicsp/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer 

      '';

      # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
      shellAliases = {
        nixud = "sudo nixos-rebuild switch";
        nixcl = "sudo nix-collect-garbage -d; nix-collect-garbage -d";
        macud = "darwin-rebuild switch --flake ~/.nix";
        maccl = "sudo nix-collect-garbage -d; nix-collect-garbage -d";
        g = "lazygit";
        d="lazydocker";
        p = "python";
        pip="pip3";
        sampler="sampler -c ~/.config/sampler/config.yml";
        v="nvim";
        y="yazi";
        c="cursor";
      #   k = "kubectl";
      #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      };
    };


    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
    };

    # zoxide
    zoxide = {
      enable = true;

      enableBashIntegration = true;
    };

  };
}
