{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-23.11 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{self, nixpkgs, nixpkgs-stable, home-manager, ... }: {

    nixosConfigurations = {
      # 这里的 my-nixos 替换成你的主机名称
      nixorb = nixpkgs.lib.nixosSystem rec{
        system = "aarch64-linux";
        # 核心参数是这个，将非默认的 nixpkgs 数据源传到其他 modules 中
        specialArgs = {
          # 注意每次 import 都会生成一个新的 nixpkgs 实例
          # 这里我们直接在 flake.nix 中创建实例， 再传递到其他子 modules 中使用
          # 这样能有效重用 nixpkgs 实例，避免 nixpkgs 实例泛滥。
          pkgs-stable = import nixpkgs-stable {
            # 这里递归引用了外部的 system 属性
            inherit system;
            # 为了拉取 chrome 等软件包，
            # 这里我们需要允许安装非自由软件
            config.allowUnfree = true;
          };
        };
        modules = [
          ./configuration.nix

          # 将 home-manager 配置为 nixos 的一个 module
          # 这样在 nixos-rebuild switch 时，home-manager 配置也会被自动部署
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # 这里的 ryan 也得替换成你的用户名
            # 这里的 import 函数在前面 Nix 语法中介绍过了，不再赘述
            home-manager.users.wicsp = import ./home.nix;

            # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
            # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
            # home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };
  };
}

