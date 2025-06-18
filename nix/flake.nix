{
  description = "nixos and home-manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          vscode = prev.vscode.override {
            commandLineArgs = "--force-device-scale-factor=2";
          };
        })
      ];
      pkgs = import nixpkgs {
        inherit overlays;
        inherit system;
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          pkgs.home-manager
          nixos-install-tools
          nixos-rebuild
        ];
      };
      homeConfigurations."zan" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home_common.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      nixosConfigurations.dottxt = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
      };
    };
}
