{ myvars, ... }:
{
  home.homeDirectory = "/home/${myvars.username}";

  home.file.".ssh/authorized_keys" = {
    text = ''
      # interactive login keys
      ${builtins.concatStringsSep "\n" (myvars.mainSshAuthorizedKeys ++ myvars.secondaryAuthorizedKeys)}
      # nix remote builder key (restricted: only allows nix-store serve)
      command="nix-store --serve --write",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ${myvars.nixRemoteBuilderPublicKey}
    '';
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      # Source nix in non-login shells (multi-user install)
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi
    '';
  };
}
