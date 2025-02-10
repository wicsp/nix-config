{ config, ... }:let
    nvimPath = "${config.home.homeDirectory}/.nixos/home/configs/nvim";
in
{
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;
}