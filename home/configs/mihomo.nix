{ config, ... }:let
    mihomoPath = "${config.home.homeDirectory}/.nixos/home/configs/mihomo";
in
{
    xdg.configFile."mihomo".source = config.lib.file.mkOutOfStoreSymlink mihomoPath;
}