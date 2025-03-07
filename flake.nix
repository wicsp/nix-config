{
  description = "A simple NixOS flake";

  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    # for macos
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-24.11";

      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-darwin.url = "github:nix-community/home-manager/release-24.11";
    home-manager-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    ragenix.url = "github:yaxitech/ragenix";

    mysecrets = {
      url = "git+ssh://git@github.com/wicsp/nix-secrets.git?shallow=1";
      flake = false;
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, darwin, home-manager, home-manager-darwin, vscode-server, ... } @ inputs: let 
  username = "wicsp";
  usermail = "wicspa@gmail.com";
  specialArgs = inputs // {inherit username usermail;};
  in{
    nixosConfigurations = {

      mio= nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./hosts/mio
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} = import ./hosts/mio/home.nix;
            home-manager.backupFileExtension = "backup";
          }
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
          })
        ];
      };
      nixpara= nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "aarch64-linux";
        modules = [
          ./hosts/nixpara
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} = import ./hosts/nixpara/home.nix;
            home-manager.backupFileExtension = "backup";
          }
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
          })
        ];
      };

      nixos=nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} = import ./hosts/nixos/home.nix;
                        home-manager.backupFileExtension = "backup";
          }
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
          })
        ];
      };
    };

    darwinConfigurations = {
      macsp =  darwin.lib.darwinSystem {
        inherit specialArgs;
        system = "aarch64-darwin";
        modules = [
          ./hosts/macsp
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs =  specialArgs;
            home-manager.users.${username} = import ./hosts/macsp/home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
    system.configurationRevision = self.rev or self.dirtyRev or null;
   };
}
