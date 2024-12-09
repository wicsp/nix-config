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
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, darwin, nixpkgs, ... }:
  let
    username = "wicsp";
    hostname = "macsp";
    specialArgs =
      inputs
      // {
        inherit username hostname;
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
