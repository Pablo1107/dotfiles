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
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    nix-on-droid.url = "github:t184256/nix-on-droid";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";
    impermanence.url = "github:nix-community/impermanence";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    emacs-copilot = {
      url = "github:zerolfx/copilot.el";
      flake = false;
    };
    firefox-csshacks = {
      url = "github:MrOtherGuy/firefox-csshacks";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "darwin";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "home-manager";
    };
    secrets = {
      # https://github.com/NixOS/nix/issues/3991#issuecomment-687897594
      url = "git+ssh://git@github.com/Pablo1107/nix-secrets.git";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, darwin, nur, emacs-overlay, nixgl, declarative-cachix, nix-on-droid, impermanence, hyprland, nix-index-database, disko, chaotic, agenix, colmena, ... }@inputs:
    let
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          buildPlatform.system = "x86_64-linux";
          hostPlatform.system = "aarch64-linux";
          permittedInsecurePackages = [ "electron-25.9.0" ];
          # self.nixpkgs.lib.optional (self.nixpkgs.obsidian.version == "1.4.16")
        };
        overlays = with builtins; [
          nixgl.overlay
          emacs-overlay.overlay
          nix-index-database.overlays.nix-index
          (import ./overlays/wrapWine.nix)
        ] ++ map (n: import ("${./overlays}/${n}")) (filter (file: !isNull (match ".*\.nix$" file)) (attrNames (readDir ./overlays)));
      };
      nixConfig = {
        nix.registry.nixpkgs.flake = nixpkgs;
        nix.registry.dotfiles.flake = self;
        home.sessionVariables = {
          NIX_PATH = "nixpkgs=${nixpkgs}:dotfiles=${self}";
        };
      };

      # not ready yet :(
      # lib = nixpkgs.lib.extend
      #   (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

      myLib = import ./lib { inherit nixpkgs; };

      # creates a list of all the modules, e.g. [ ./modules/dunst.nix ./modules/emacs.nix etc... ]
      hmModules = with builtins; [
        declarative-cachix.homeManagerModules.declarative-cachix-experimental
        impermanence.nixosModules.home-manager.impermanence
        nix-index-database.hmModules.nix-index
        nur.hmModules.nur
        nixConfig
        agenix.homeManagerModules.default
        # ./secrets/default.nix
      ] ++ map (n: "${./modules/home-manager}/${n}") (attrNames (readDir ./modules/home-manager));
      darwinModules = [
        agenix.darwinModules.default
        # ./secrets/default.nix
      ] ++ map (n: "${./modules/darwin}/${n}") (builtins.attrNames (builtins.readDir ./modules/darwin));
      nixosModules = [
        declarative-cachix.nixosModules.declarative-cachix
        chaotic.nixosModules.default
        agenix.nixosModules.default
        # ./secrets/default.nix
      ] ++ map (n: "${./modules/nixos}/${n}") (builtins.attrNames (builtins.readDir ./modules/nixos));
    in
    {
      homeConfigurations = {
        pablo = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = nixpkgsConfig.config;
          };
          modules = [
            ./hosts/t14s/home.nix
            {
              nixpkgs = nixpkgsConfig;
            }
            hyprland.homeManagerModules.default
          ] ++ hmModules;
          extraSpecialArgs = {
            inherit myLib;
            inherit inputs;
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
            ./hosts/deck/home.nix
          ] ++ hmModules;
          extraSpecialArgs = {
            inherit myLib;
            inherit inputs;
            pkgs-stable = import nixpkgs-stable {
              system = "x86_64-linux";
              config = nixpkgsConfig.config;
            };
          };
        };
      };
      darwinConfigurations.FQ3VX4RWV4 = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        modules = darwinModules ++ [
          ./hosts/darwin/nix-darwin.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [ ] ++ hmModules;
            home-manager.extraSpecialArgs = {
              inherit myLib;
              inherit inputs;
              pkgs-stable = import nixpkgs-stable {
                inherit system;
                config = nixpkgsConfig.config;
              };
            };
            home-manager.users."pablo.dealbera.ctr" = { pkgs, ... }: {
              imports = [
                ./hosts/darwin/home.nix
              ];
              home = {
                username = "pablo.dealbera.ctr";
                homeDirectory = "/Users/pablo.dealbera.ctr";
              };
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
      nixOnDroidConfigurations = {
        default = nix-on-droid.lib.nixOnDroidConfiguration {
          modules = [
            ./hosts/sm-f936b/nix-on-droid.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ ] ++ hmModules;
              home-manager.extraSpecialArgs = {
                inherit myLib;
                inherit inputs;
              };
              home-manager.config = { pkgs, ... }: {
                imports = [ ./hosts/sm-f936b/home.nix ];
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
            overlays = [
              nix-on-droid.overlays.default
            ] ++ nixpkgsConfig.overlays;
          };
        };
      };
      nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./hosts/rpi/nixos.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ ] ++ hmModules;
            home-manager.extraSpecialArgs = {
              inherit myLib;
              inherit inputs;
            };
            home-manager.users.pablo = { pkgs, ... }: {
              imports = [ ./hosts/rpi/home.nix ];
            };
          }
          {
            config = {
              # Disable zstd compression
              sdImage.compressImage = false;
              system = {
                stateVersion = "22.05";
              };
            };
          }
        ];
      };
      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/vmware-image.nix"
          ./hosts/vm/nixos.nix
          {
            config = {
              vmware.baseImageSize = 32 * 1024;
            };
          }
        ];
      };
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = nixosModules ++ [
          disko.nixosModules.disko
          ./hosts/server/nixos.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ ] ++ hmModules;
            home-manager.extraSpecialArgs = {
              inherit myLib;
              inherit inputs;
            };
            home-manager.users.pablo = { pkgs, ... }: {
              imports = [ ./hosts/server/home.nix ];
            };
          }
        ];
      };
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            config = nixpkgsConfig.config;
            overlays = nixpkgsConfig.overlays;
          };

          # This parameter functions similarly to `sepcialArgs` in `nixosConfigurations.xxx`,
          # used for passing custom arguments to all submodules.
          specialArgs = {
            inherit nixpkgs;
            inherit inputs;
          };
        };

        # Host name = "server"
        "server" = { name, nodes, ... }: {
          # Parameters related to remote deployment
          deployment = inputs.secrets.deployment;

          # This parameter functions similarly to `modules` in `nixosConfigurations.xxx`,
          # used for importing all submodules.
          imports = nixosModules ++ [
            disko.nixosModules.disko
            ./hosts/server/nixos.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ ] ++ hmModules;
              home-manager.extraSpecialArgs = {
                inherit myLib;
                inherit inputs;
              };
              home-manager.users.pablo = { pkgs, ... }: {
                imports = [ ./hosts/server/home.nix ];
              };
              home-manager.users.root = { pkgs, ... }: {
                imports = [ ./hosts/server/root-home.nix ];
              };
            }
          ];
        };
      };
      devShell = myLib.forAllSystems (system:
        let
          pkgs = myLib.nixpkgsFor.${system};
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            just
            rpiboot
            nixos-rebuild
            colmena.packages.${system}.colmena
            agenix.packages.${system}.default
          ];
        }
      );
      templates = {
        template = {
          description = "My flake template";
          path = ./template;
        };
      };
      nixpkgs = import nixpkgs {
        system = "x86_64-linux";
        config = nixpkgsConfig.config;
        overlays = nixpkgsConfig.overlays;
      };
    };
}
