{
  description = "MWE of nix-darwin and home-manager flake issue";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, darwin, nixpkgs, home-manager }: {
    darwinConfigurations."test" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        ({ config, pkgs, ... }: { system.stateVersion = 4; })
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.test = { home.stateVersion = "21.11"; };
        }
      ];
      inputs = {
        pkgs = nixpkgs;
        homemanagerflake = home-manager;
      };
    };
  };
}
