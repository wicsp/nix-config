{
  config,
  pkgs,
  ...
}: let
  nvimPath = "${config.home.homeDirectory}/nix-config/home/configs/nvim";
in {
  home.packages = with pkgs; [
    neovim
  ];
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;
}
