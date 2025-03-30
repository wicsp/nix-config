{ config, pkgs, ... }:let
    mihomoPath = "${config.home.homeDirectory}/.nix/home/configs/mihomo";
in
{
    home.packages = with pkgs; [
        clash-meta
    ];
    xdg.configFile."mihomo".source = config.lib.file.mkOutOfStoreSymlink mihomoPath;
}