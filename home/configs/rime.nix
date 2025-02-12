{ config, ... }:let
    rimePath = "${config.home.homeDirectory}/.nixos/home/configs/Rime";
in
{
      home.file."Library/Rime".source = config.lib.file.mkOutOfStoreSymlink rimePath;
}

