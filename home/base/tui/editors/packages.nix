{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages =
    with pkgs;
    (
      # -*- Data & Configuration Languages -*-#
      [
        #-- nix
        nil
        nixd
        statix # Lints and suggestions for the nix programming language
        deadnix # Find and remove unused code in .nix source files
        nixfmt # Nix Code Formatter

        #-- nickel lang
        nickel

        #-- json like
        jsonnet
        jsonnet-language-server
        taplo # TOML language server / formatter / validator
        nodePackages.yaml-language-server
        actionlint # GitHub Actions linter

        #-- dockerfile
        hadolint # Dockerfile linter
        dockerfile-language-server

        #-- markdown
        marksman # language server for markdown
        glow # markdown previewer
        pandoc # document converter
        pkgs-unstable.hugo # static site generator

        #-- sql
        sqlfluff
      ]
      ++
        #-*- General Purpose Languages -*-#
        [
          #-- c/c++
          cmake
          cmake-language-server
          gnumake
          checkmake
          # c/c++ compiler, required by nvim-treesitter!
          gcc
          gdb
          # c/c++ tools with clang-tools, the unwrapped version won't
          # add alias like `cc` and `c++`, so that it won't conflict with gcc
          # llvmPackages.clang-unwrapped
          clang-tools
          lldb
          vscode-extensions.vadimcn.vscode-lldb.adapter # codelldb - debugger

          #-- python
          (python313.withPackages (
            ps: with ps; [
              # python language server
              pyright
              ruff
              uv # python project package manager
            ]
          ))

          #-- rust
          # we'd better use the rust-overlays for rust development
          pkgs-unstable.rustc
          pkgs-unstable.rust-analyzer
          pkgs-unstable.cargo # rust package manager
          pkgs-unstable.rustfmt
          pkgs-unstable.clippy # rust linter

          #-- golang
          go
          gomodifytags
          iferr # generate error handling code for go
          impl # generate function implementation for go
          gotools # contains tools like: godoc, goimports, etc.
          gopls # go language server
          delve # go debugger

          #-- lua
          stylua
          lua-language-server

          #-- bash
          nodePackages.bash-language-server
          shellcheck
          shfmt
        ]
      ++ [
        proselint # English prose linter

        #-- Optional Requirements:
        nodePackages.prettier # common code formatter
        fzf
        gdu # disk usage analyzer, required by AstroNvim
        (ripgrep.override { withPCRE2 = true; }) # recursively searches directories for a regex pattern
      ]
    );
}
