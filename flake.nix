{
  description = "Example nix-darwin system flake";

  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
  let
    username = "wicsp";
    useremail = "wicspa@gmail.com";
    hostname = "macsp";
    specialArgs =
      inputs
      // {
        inherit username useremail hostname;
      };
  in
  {
    system.configurationRevision = self.rev or self.dirtyRev or null;
    darwinConfigurations."macsp" = darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [ 
        ./modules/nix-core.nix
        ./modules/system.nix
        ./modules/apps.nix
      ];
    };
  };
}
