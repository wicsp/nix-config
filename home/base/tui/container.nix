{ pkgs, ... }:
{
  home.packages = with pkgs; [
    podman-compose
    dive # explore docker layers
    lazydocker # Docker terminal UI.
    skopeo # copy/sync images between registries and local storage
  ];
}
