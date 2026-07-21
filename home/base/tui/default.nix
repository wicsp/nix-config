{ ... }:
{
  # TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # imports = mylib.scanPaths ./.;
  imports = [
    ./ssh.nix
    ./dev-tools.nix
    # ./encryption
    # ./gpg
    # ./password-store
    # ./cloud
    # ./zellij
    ./editors
    ./container.nix
  ];
}
