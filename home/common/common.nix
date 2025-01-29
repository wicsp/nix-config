{ config, pkgs, ... }:let
    nvimPath = "${config.home.homeDirectory}/.nixos/home/common/nvim";
in
{
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;
    home.packages = with pkgs;[
        atuin
        nushell
        neovim
        # 如下是我常用的一些命令行工具，你可以根据自己的需要进行增删
        # archives
        zip
        unzip
        # p7zip
        # utils
        ripgrep # recursively searches directories for a regex pattern
        jq # A lightweight and flexible command-line JSON processor
        yq-go # yaml processor https://github.com/mikefarah/yq
        eza # A modern replacement for ‘ls’
        fzf # A command-line fuzzy finder
        fastfetch
        cowsay
        file
        which
        tree    # nix related
        #
        # it provides the command `nom` works just like `nix`
        # with more details log output
        # nix-output-monitor
        glow # markdown previewer in terminal
        btop 
        lsof 
    ];
}