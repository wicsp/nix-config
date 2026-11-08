{ pkgs, ... }:
{
  # Keep development and test runtimes aligned with Lumio's packageManager.
  # Override only Bun, leaving the shared nixpkgs pins unchanged.
  home.packages = [
    (pkgs.bun.overrideAttrs (
      finalAttrs: previousAttrs: {
        version = "1.4.4";
        src = finalAttrs.passthru.sources.${pkgs.stdenv.hostPlatform.system};
        passthru = previousAttrs.passthru // {
          sources = {
            aarch64-darwin = pkgs.fetchurl {
              url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-darwin-aarch64.zip";
              hash = "sha256-wkDX8My5DCY6hJ/NsJt+5iYw2SE0jtaq/ahrnVd7xRA=";
            };
            aarch64-linux = pkgs.fetchurl {
              url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-linux-aarch64.zip";
              hash = "sha256-uqa7NvUdblhWHgK76oJQOKnfRU9nPW13bou/hvjHhQ4=";
            };
            x86_64-linux = pkgs.fetchurl {
              url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-linux-x64-baseline.zip";
              hash = "sha256-4ERutVmVdy65iUvrrppr42jZhai5Jx7hJEhvmUbu3XY=";
            };
          };
        };
      }
    ))
  ];
}
