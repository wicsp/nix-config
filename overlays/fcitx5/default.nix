# 为了不使用默认的 rime-data，改用我自定义的灵明输入法数据，这里需要 override
# 参考 https://github.com/NixOS/nixpkgs/blob/e4246ae1e7f78b7087dce9c9da10d28d3725025f/pkgs/tools/inputmethods/fcitx5/fcitx5-rime.nix
_:
(_: super: {
  # 灵明输入法配置，数据来自本地下载的「靈明輸入法_v3.11.0-beta.20260212.132452」。
  rime-data = ./rime-data-yuling;
  fcitx5-rime = super.fcitx5-rime.override { rimeDataPkgs = [ ./rime-data-yuling ]; };

  # used by macOS Squirrel
  yuling-squirrel = ./rime-data-yuling;
})
