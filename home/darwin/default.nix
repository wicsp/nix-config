{ config, pkgs, ... }:
{
    imports =
        [
            ../configs/aerospace.nix
            ../configs/sketchybar.nix
            ../configs/kitty.nix
        ];
}
