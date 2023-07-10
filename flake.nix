{
  description = "A Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/22.11";
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
    comma.url = "github:nix-community/comma/v1.4.1";
    comma.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, darwin, nur, nixgl, emacs-overlay, declarative-cachix, nix-on-droid, impermanence, comma }:
    let
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          nur.overlay
          nixgl.overlay
          emacs-overlay.overlay
          comma.overlays.default
          (import ./overlays/vifm.nix)
          (import ./overlays/yabai.nix)
          (import ./overlays/local-ai.nix)
          (import ./overlays/local-shell-gpt.nix)
        ];
      };

      # not ready yet :(
      # lib = nixpkgs.lib.extend
      #   (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

      myLib = import ./lib { inherit nixpkgs; };

      # creates a list of all the modules, e.g. [ ./modules/dunst.nix ./modules/emacs.nix etc... ]
      hmModules = map (n: "${./modules/home-manager}/${n}") (builtins.attrNames (builtins.readDir ./modules/home-manager));
      darwinModules = map (n: "${./modules/darwin}/${n}") (builtins.attrNames (builtins.readDir ./modules/darwin));
    in
    {
      homeConfigurations = {
        pablo = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = nixpkgsConfig.config;
          };
          modules = [
            ./config/nixpkgs/home.nix
            declarative-cachix.homeManagerModules.declarative-cachix-experimental
            impermanence.nixosModules.home-manager.impermanence
            {
              nixpkgs = nixpkgsConfig;
            }
          ] ++ hmModules;
          extraSpecialArgs = {
            inherit myLib;
            pkgs-stable = import nixpkgs-stable {
              system = "x86_64-linux";
              config = nixpkgsConfig.config;
            };
          };
        };
        deck = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = nixpkgsConfig.config;
          };
          modules = [
            ./config/nixpkgs/deck-home.nix
            declarative-cachix.homeManagerModules.declarative-cachix-experimental
            impermanence.nixosModules.home-manager.impermanence
            {
              nixpkgs = nixpkgsConfig;
            }
          ] ++ hmModules;
          extraSpecialArgs = {
            inherit myLib;
            pkgs-stable = import nixpkgs-stable {
              system = "x86_64-linux";
              config = nixpkgsConfig.config;
            };
          };
        };
      };
      darwinConfigurations.pablo = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        modules = darwinModules ++ [
          ./config/nix-darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              impermanence.nixosModules.home-manager.impermanence
            ] ++ hmModules;
            home-manager.extraSpecialArgs = {
              inherit myLib;
              pkgs-stable = import nixpkgs-stable {
                inherit system;
                config = nixpkgsConfig.config;
              };
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
          modules = [
            ./config/nix-on-droid/config.nix
            {
              #nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                impermanence.nixosModules.home-manager.impermanence
              ] ++ hmModules;
              home-manager.extraSpecialArgs = {
                inherit myLib;
              };
              home-manager.config = { pkgs, ... }: {
                imports = [ ./config/nixpkgs/android.nix ];
              };
            }
          ];
          extraSpecialArgs = {
            pkgs-stable = import nixpkgs-stable {
              system = "aarch64-linux";
              config = nixpkgsConfig.config;
            };
          };
          # your own pkgs instance (see nix-on-droid.overlay for useful additions)
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config = nixpkgsConfig.config;
          };
        };
      };
      devShell = myLib.forAllSystems (system:
        let
          pkgs = myLib.nixpkgsFor.${system};
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            just
          ];
        }
      );
    };
}
