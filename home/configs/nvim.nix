{ config, pkgs, ... }:let
    nvimPath = "${config.home.homeDirectory}/.nixos/home/configs/nvim";
in
{
    home.packages = with pkgs; [
        neovim
    ];
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;
}