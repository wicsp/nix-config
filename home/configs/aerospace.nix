{ config, ... }:let
    aerospacePath = "${config.home.homeDirectory}/.nixos/home/configs/aerospace";
in
{
    xdg.configFile."aerospace".source = config.lib.file.mkOutOfStoreSymlink aerospacePath;
}