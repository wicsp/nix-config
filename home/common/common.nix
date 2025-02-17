{ config, pkgs, ... }:
{
    imports =
        [
        ../configs/nvim.nix
        ];
    home.packages = with pkgs;[
        atuin
        nushell
        neovim
        # archives
        zip
        unzip
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
        tree   # nix related
        # it provides the command `nom` works just like `nix`
        # with more details log output
        # nix-output-monitor
        glow # markdown previewer in terminal
        btop 
        lsof 
        zellij
        lua-language-server
        lazygit
    ];
}
