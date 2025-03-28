{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    sketchybar
  ];

  # 启用 sketchybar 服务
  services.sketchybar = {
    enable = true;
    # 这里可以添加更多 sketchybar 的具体配置
  };
}