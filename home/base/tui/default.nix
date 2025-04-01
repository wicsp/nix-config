{mylib, ...}: {
  # TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # imports = mylib.scanPaths ./.;
  imports = [
    ./shell.nix
    ./ssh.nix
    ./dev-tools.nix
    # ./encryption
    # ./gpg
    # ./password-store
    ./cloud
    ./zellij
    ./editors
  ];
}
