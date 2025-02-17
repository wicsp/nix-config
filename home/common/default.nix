{ config, pkgs, ... }:
{
  imports =
    [
      ./common.nix
      ./atuin.nix
    ];
  
  programs = {
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
    
    # zoxide
    zoxide = {
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
        export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
        export BARK_ID="j7kb5DDBxSbMdr44T2qbyS"
        export EDITOR="nvim"

        
      '';

      # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
      shellAliases = {
        nixupdate = "sudo nixos-rebuild switch";
        nixclear = "sudo nix-collect-garbage -d; nix-collect-garbage -d";
        lzg = "lazygit";
        lzd="lazydocker";
        python = "python3";
        pip="pip3";
        sampler="sampler -c ~/.config/sampler/config.yml";
        vim="nvim";
      #   k = "kubectl";
      #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      };
    };

  };
}
