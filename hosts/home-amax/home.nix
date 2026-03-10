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
    '';
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        Hostname github.com
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes
    '';
  };
}
