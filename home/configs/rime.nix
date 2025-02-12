{ config, ... }:let
    rimePath = "${config.home.homeDirectory}/.nixos/home/configs/rime";
in
{
      home.file."Library/Rime".source = config.lib.file.mkOutOfStoreSymlink rimePath;
}

