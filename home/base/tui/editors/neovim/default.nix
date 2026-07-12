{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
###############################################################################
#
#  AstroNvim's configuration and all its dependencies(lsp, formatter, etc.)
#
#e#############################################################################
let
  shellAliases = {
    v = "nvim";
    vdiff = "nvim -d";
  };
in
{
  xdg.configFile."nvim".source = ./nvchad;
  # Disable catppuccin to avoid conflict with my non-nix config.
  catppuccin.nvim.enable = false;

  home.shellAliases = shellAliases;

  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;

    # Disable Ruby/Python support (not needed by our plugins)
    withRuby = false;
    withPython3 = false;

    # defaultEditor = true; # set EDITOR at system-wide level
    viAlias = true;
    vimAlias = true;

    # These environment variables are needed to build and run binaries
    # with external package managers like mason.nvim.
    #
    # LD_LIBRARY_PATH is also needed to run the non-FHS binaries downloaded by mason.nvim.
    # it will be set by nix-ld, so we do not need to set it here again.
    extraWrapperArgs = with pkgs; [
      # LIBRARY_PATH is used by gcc before compilation to search directories
      # containing static and shared libraries that need to be linked to your program.
      "--suffix"
      "LIBRARY_PATH"
      ":"
      "${lib.makeLibraryPath [
        stdenv.cc.cc
        zlib
      ]}"

      # PKG_CONFIG_PATH is used by pkg-config before compilation to search directories
      # containing .pc files that describe the libraries that need to be linked to your program.
      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
        stdenv.cc.cc
        zlib
      ]}"
    ];
  };
}
