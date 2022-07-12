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
    nix-on-droid.url = "github:t184256/nix-on-droid";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, home-manager, darwin, nur, nixgl, emacs-overlay, declarative-cachix, nix-on-droid, impermanence }:
    let
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (pkg: true);
        };
        overlays = [
          nur.overlay
          nixgl.overlay
          emacs-overlay.overlay
          (import ./overlays/vifm.nix)
        ];
      };

      # not ready yet :(
      # lib = nixpkgs.lib.extend
      #   (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

      myLib = import ./lib { };

      # creates a list of all the modules, e.g. [ ./modules/dunst.nix ./modules/emacs.nix etc... ]
      personalModules = map (n: "${./modules}/${n}") (builtins.attrNames (builtins.readDir ./modules));
    in
    {
      homeConfigurations = {
        pablo = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [
            ./config/nixpkgs/home.nix
            declarative-cachix.homeManagerModules.declarative-cachix-experimental
            impermanence.nixosModules.home-manager.impermanence
            {
              nixpkgs = nixpkgsConfig;
            }
          ] ++ personalModules;
          extraSpecialArgs = {
            inherit myLib;
          };
        };
      };
      darwinConfigurations.pablo = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./config/nix-darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = personalModules;
            home-manager.extraSpecialArgs = {
              inherit myLib;
            };
            home-manager.users.pablo = { pkgs, ... }: {
              imports = [
                ./config/nixpkgs/darwin-home.nix
              ];
              home = {
                username = "pablo";
                homeDirectory = "/Users/pablo";
              };
            };
          }
        ];
        inputs = { inherit darwin nixpkgs; };
      };
      nixOnDroidConfigurations = {
        sm-g950f = nix-on-droid.lib.nixOnDroidConfiguration {
          config = ./config/nix-on-droid/config.nix;
          system = "aarch64-linux";
          extraModules = [
            # import source out-of-tree modules like:
            # flake.nixOnDroidModules.module
            {
              #nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules =[
                impermanence.nixosModules.home-manager.impermanence
              ] ++ personalModules;
              home-manager.extraSpecialArgs = {
                inherit myLib;
              };
              home-manager.config = { pkgs, ... }: {
                imports = [ ./config/nixpkgs/android.nix ];
              };
            }
          ];
          extraSpecialArgs = {
            # arguments to be available in every nix-on-droid module
          };
          # your own pkgs instance (see nix-on-droid.overlay for useful additions)
          # pkgs = ...;
        };
      };
    };
}
