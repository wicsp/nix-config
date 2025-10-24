{
  description = "WICSP's nix configuration for both NixOS and macOS";
  # this is yoink from ryan4yin XD

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  outputs = inputs: import ./outputs inputs;

  # the nixConfig here only affects the flake itself, not the system configuration!
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [
      # "https://anyrun.cachix.org"
      # "https://nix-gaming.cachix.org"
      # "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];

    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    trusted-users = ["root" "wicsp"];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs. The most widely used is github:owner/name/reference,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-ollama.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixpkgs-patched.url = "github:ryan4yin/nixpkgs/nixos-unstable-patched";  # custom nixpkgs with some patches，i dont have one yet

    # for macos
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # darwin = {
    #   url = "github:LnL7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs-darwin";
    # };
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-25.05";

      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/catppuccin/nix
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation = {
      url = "github:nix-community/preservation";
    };

    impermanence.url = "github:nix-community/impermanence";

    # community wayland nixpkgs
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # anyrun - a wayland launcher
    anyrun = {
      url = "github:/anyrun-org/anyrun/v25.9.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # generate iso/qcow2/docker/... image from nixos configuration
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO lock agenix
    agenix.url = "github:yaxitech/ragenix";

    disko = {
      url = "github:nix-community/disko/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nuenv = {
      url = "github:DeterminateSystems/nuenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    blender-bin = {
      url = "github:edolstra/nix-warez?dir=blender";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # i dont need a nixos-apple-silicon repo yet, i am using nix-darwin for my macsp
    # nixos-apple-silicon = {
    #   # 2025-10-07 asahi-6.16.8-1
    #   url = "github:nix-community/nixos-apple-silicon/24ab28e47b586f741910b3a2f0428f3523a0fff3";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    niri.url = "github:sodiboo/niri-flake";

    # -------------- Gaming ---------------------
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ########################  Some non-flake repositories  #########################################
    nu_scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };

    ########################  My own repositories  #########################################

    # my private secrets, it's a private repository, you need to replace it with your own.
    # use ssh protocol to authenticate via ssh-agent/ssh-key, and shallow clone to save time
    mysecrets = {
      url = "git+ssh://git@github.com/wicsp/nix-secrets.git?shallow=1";
      flake = false;
    };

    # i dont need a asahi-firmware repo yet, i am using nix-darwin for my macsp
    # my-asahi-firmware = {
    #   url = "git+ssh://git@github.com/ryan4yin/asahi-firmware.git?shallow=1";
    #   flake = false;
    # };

    # my wallpapers
    wallpapers = {
      url = "github:wicsp/wallpapers";
      flake = false;
    };

    # nur-ryan4yin = {
    #   url = "github:ryan4yin/nur-packages";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
  };

  # outputs = { self, nixpkgs, nixpkgs-darwin, darwin, home-manager, home-manager-darwin, vscode-server, ... } @ inputs: let
  # username = "wicsp";
  # usermail = "wicspa@gmail.com";
  # specialArgs = inputs // {inherit username usermail;};
  # in{
  #   homeConfigurations = {
  #     wicsp = home-manager.lib.homeManagerConfiguration {
  #       pkgs = nixpkgs.legacyPackages.x86_64-linux;
  #       extraSpecialArgs = specialArgs;
  #       modules = [
  #         ./hosts/cs/home.nix
  #       ];
  #     };
  #   };

  #   nixosConfigurations = {
  #     mio= nixpkgs.lib.nixosSystem {
  #       inherit specialArgs;
  #       system = "x86_64-linux";
  #       modules = [
  #         ./hosts/mio
  #         home-manager.nixosModules.home-manager
  #         {
  #           home-manager.useGlobalPkgs = true;
  #           home-manager.useUserPackages = true;
  #           home-manager.extraSpecialArgs = inputs // specialArgs;
  #           home-manager.users.${username} = import ./hosts/mio/home.nix;
  #           home-manager.backupFileExtension = "backup";
  #         }
  #         vscode-server.nixosModules.default
  #         ({ config, pkgs, ... }: {
  #           services.vscode-server.enable = true;
  #         })
  #       ];
  #     };
  #     nixpara= nixpkgs.lib.nixosSystem {
  #       inherit specialArgs;
  #       system = "aarch64-linux";
  #       modules = [
  #         ./hosts/nixpara
  #         home-manager.nixosModules.home-manager
  #         {
  #           home-manager.useGlobalPkgs = true;
  #           home-manager.useUserPackages = true;
  #           home-manager.extraSpecialArgs = inputs // specialArgs;
  #           home-manager.users.${username} = import ./hosts/nixpara/home.nix;
  #           home-manager.backupFileExtension = "backup";
  #         }
  #         vscode-server.nixosModules.default
  #         ({ config, pkgs, ... }: {
  #           services.vscode-server.enable = true;
  #         })
  #       ];
  #     };

  #     nixos=nixpkgs.lib.nixosSystem {
  #       inherit specialArgs;
  #       system = "x86_64-linux";
  #       modules = [
  #         ./hosts/nixos
  #         home-manager.nixosModules.home-manager
  #         {
  #           home-manager.useGlobalPkgs = true;
  #           home-manager.useUserPackages = true;
  #           home-manager.extraSpecialArgs = inputs // specialArgs;
  #           home-manager.users.${username} = import ./hosts/nixos/home.nix;
  #                       home-manager.backupFileExtension = "backup";
  #         }
  #         vscode-server.nixosModules.default
  #         ({ config, pkgs, ... }: {
  #           services.vscode-server.enable = true;
  #         })
  #       ];
  #     };
  #   };

  #   darwinConfigurations = {
  #     macsp =  darwin.lib.darwinSystem {
  #       inherit specialArgs;
  #       system = "aarch64-darwin";
  #       modules = [
  #         ./hosts/macsp
  #         home-manager.darwinModules.home-manager
  #         {
  #           home-manager.useGlobalPkgs = true;
  #           home-manager.useUserPackages = true;
  #           home-manager.extraSpecialArgs =  specialArgs;
  #           home-manager.users.${username} = import ./hosts/macsp/home.nix;
  #           home-manager.backupFileExtension = "backup";
  #         }
  #       ];
  #     };
  #   };
  #   system.configurationRevision = self.rev or self.dirtyRev or null;
  # };
}
