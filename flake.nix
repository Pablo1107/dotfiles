{
  description = "A Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nixgl.url = "github:guibou/nixGL";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
  };

  outputs = { self, nixpkgs, home-manager, darwin, nur, nixgl, emacs-overlay, declarative-cachix }: {
    homeConfigurations = {
      pablo = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/pablo";
        username = "pablo";
        stateVersion = "21.05";
        configuration = {
          imports = [
            ./config/nixpkgs/home.nix
            declarative-cachix.homeManagerModules.declarative-cachix
          ];
          nixpkgs = {
            config = { allowUnfree = true; };
            overlays = [
              nur.overlay
              nixgl.overlay
              emacs-overlay.overlay
            ];
          };
        };
      };
    };
    darwinConfigurations.Pablos-MacBook-Air = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./config/nix-darwin/configuration.nix
        home-manager.darwinModules.home-manager
      ];
      inputs = { inherit darwin nixpkgs; };
    };
  };
}
