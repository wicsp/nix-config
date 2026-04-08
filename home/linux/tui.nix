{ lib, ... }:
{
  imports = [
    ../base/core
    ../base/tui
    ../base/home.nix

    ./base
  ];

  # Catppuccin's Home Manager modules import theme assets from derivation-backed
  # paths during evaluation. That is fine when evaluating on the target platform,
  # but it breaks cross-platform colmena evals from macOS for x86_64-linux TUI
  # hosts. Desktop hosts keep Catppuccin via `home/linux/gui.nix`.
  catppuccin.enable = lib.mkForce false;
}
