{
  self,
  nixpkgs,
  pre-commit-hooks,
  ...
}@inputs:
let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib; };
  myvars = import ../vars { inherit lib; };

  # Add my custom lib, vars, nixpkgs instance, and all the inputs to specialArgs,
  # so that I can use them in all my nixos/home-manager/darwin modules.
  genSpecialArgs =
    system:
    inputs
    // {
      inherit mylib myvars;

      # Preserve the existing special argument while sharing the primary pin.
      pkgs-unstable = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-x64 = import nixpkgs {
        system = "x86_64-linux";

        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
    };

  # This is the args for all the haumea modules in this folder.
  args = {
    inherit
      inputs
      lib
      mylib
      myvars
      genSpecialArgs
      ;
  };
  # modules for each supported system
  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
    # aarch64-linux = import ./aarch64-linux (args // {system = "aarch64-linux";});
    # riscv64-linux = import ./riscv64-linux (args // {system = "riscv64-linux";});
  };
  darwinSystems = {
    aarch64-darwin = import ./aarch64-darwin (args // { system = "aarch64-darwin"; });
  };
  homeSystems = {
    x86_64-home = import ./x86_64-home (args // { system = "x86_64-linux"; });
  };

  # allSystems = nixosSystems // darwinSystems // homeSystems;
  allSystems = nixosSystems // darwinSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;
  homeSystemValues = builtins.attrValues homeSystems;
  allSystemValues = nixosSystemValues ++ darwinSystemValues;

  # Helper function to generate a set of attributes for each system
  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);
in
{
  # Project helpers and aggregate test status use the standard `lib` output.
  lib = mylib // {
    evalTests = lib.lists.all (it: it.evalTests == { }) (allSystemValues ++ homeSystemValues);
  };

  # NixOS Hosts
  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) nixosSystemValues
  );

  # Colmena - remote deployment via SSH
  colmena = {
    meta =
      (
        let
          system = "x86_64-linux";
        in
        {
          # colmena's default nixpkgs & specialArgs
          nixpkgs = import nixpkgs { inherit system; };
          specialArgs = genSpecialArgs system;
        }
      )
      // {
        # per-node nixpkgs & specialArgs
        nodeNixpkgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeNixpkgs or { }) nixosSystemValues
        );
        nodeSpecialArgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeSpecialArgs or { }) nixosSystemValues
        );
      };
  }
  // lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) nixosSystemValues);

  # macOS Hosts
  darwinConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.darwinConfigurations or { }) darwinSystemValues
  );

  # Home Manager Configurations
  homeConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.homeConfigurations or { }) homeSystemValues
  );

  # Packages
  packages = forAllSystems (system: allSystems.${system}.packages or { });

  checks = forAllSystems (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      evalTestsPassed = allSystems.${system}.evalTests == { };
    in
    {
      # A standard flake check must be a derivation, not a boolean.
      eval-tests = pkgs.runCommand "eval-tests" { } (
        if evalTestsPassed then
          ''
            touch "$out"
          ''
        else
          ''
            echo "evaluation tests failed" >&2
            exit 1
          ''
      );

      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = mylib.relativeToRoot ".";
        hooks = {
          nixfmt = {
            enable = true;
            settings.width = 100;
          };
          # Checks report drift; explicit formatting commands perform writes.
          typos = {
            enable = true;
            settings = {
              write = false;
              configPath = ".typos.toml";
              exclude = "rime-data/";
            };
          };
          prettier = {
            enable = true;
            settings = {
              write = false;
              configPath = ".prettierrc.yaml";
            };
          };
          deadnix = {
            enable = true;
            excludes = [
              "outputs/.*/src/.*\\.nix"
              "home/linux/gui/hyprland/default\\.nix"
            ];
          };
          statix.enable = true;
        };
      };
    }
  );

  # Development Shells
  devShells = forAllSystems (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
          bashInteractive
          # fix `cc` replaced by clang, which causes nvim-treesitter compilation error
          gcc
          # Nix-related
          nixfmt
          deadnix
          statix
          # spell checker
          typos
          # code formatter
          prettier
        ];
        name = "dots";
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    }
  );

  # Format the nix code in this flake
  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
}
