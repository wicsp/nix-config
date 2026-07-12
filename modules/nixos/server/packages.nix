{ pkgs, ... }:
{
  # for security reasons, do not load neovim's user config
  # since EDITOR may be used to edit some critical files
  environment.variables.EDITOR = "nvim --clean";

  environment.systemPackages = with pkgs; [
    # core maintenance
    neovim
    git
    just

    # shell and text processing
    jq
    fd
    (ripgrep.override { withPCRE2 = true; })
    gnused
    gawk

    # archives and transfer
    xz
    zstd
    unzipNLS
    rsync

    # troubleshooting
    btop
    duf
    ncdu
    lsof
    strace
    psmisc

    # networking
    curl
    wget
    dnsutils
    mtr
    tcpdump

    # misc
    file
    which
    tree
  ];
}
