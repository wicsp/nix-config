{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        Hostname github.com
        # github is controlled by macsp~
        IdentityFile ~/.ssh/id_rsa_github
        # Specifies that ssh should only use the identity file explicitly configured above
        # required to prevent sending default identity files first.
        IdentitiesOnly yes
    '';
  };
  # TODO: add emacs
  # modules.editors.vim = {
  #   enable = true;
  # };
}
