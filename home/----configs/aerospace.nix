{
  config,
  pkgs,
  ...
}: let
  aerospacePath = "${config.home.homeDirectory}/nix-config/home/configs/aerospace";
in {
  home.packages = with pkgs; [
    aerospace
  ];
  xdg.configFile."aerospace".source = config.lib.file.mkOutOfStoreSymlink aerospacePath;
}
