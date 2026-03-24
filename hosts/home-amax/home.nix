{ myvars, ... }:
{
  home.homeDirectory = "/home/${myvars.username}";

  programs.bash = {
    enable = true;
    initExtra = ''
      # Source nix in non-login shells (multi-user install)
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi

      # clashctl START
      # 加载 clashctl 命令
      . ~/clashctl/scripts/cmd/clashctl.sh
      # 自动开启代理环境
      watch_proxy
      # clashctl END
    '';
  };
}
