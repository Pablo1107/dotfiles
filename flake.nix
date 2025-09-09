{
  description = "A Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-23_11.url = "github:nixos/nixpkgs/nixos-23.11";
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
      url = "github:copilot-emacs/copilot.el";
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
      url = "git+file:///home/pablo/nix-secrets";
    };
    nix-std.url = "github:chessai/nix-std";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    paisa = {
      url = "github:ananthakumaran/paisa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mobile-nixos = {
      url = "github:mobile-nixos/mobile-nixos";
      flake = false;
    };
    gnome-mobile = {
      url = "github:chuangzhu/nixpkgs-gnome-mobile";
    };
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-23_11, home-manager, darwin, nur, emacs-overlay, nixgl, declarative-cachix, nix-on-droid, impermanence, hyprland, nix-index-database, disko, chaotic, agenix, spicetify-nix, mobile-nixos, gnome-mobile, nix-software-center, nix-minecraft, ... }@inputs:
    let
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          buildPlatform.system = "x86_64-linux";
          hostPlatform.system = "aarch64-linux";
          # HACK: until https://github.com/NixOS/nixpkgs/issues/360592 is resolved
          # needed for sonarr
          permittedInsecurePackages = [
            "aspnetcore-runtime-6.0.36"
            "aspnetcore-runtime-wrapped-6.0.36"
            "dotnet-sdk-6.0.428"
            "dotnet-sdk-wrapped-6.0.428"
          ];
          # self.nixpkgs.lib.optional (self.nixpkgs.obsidian.version == "1.4.16")
        };
        overlays = with builtins; [
          nixgl.overlay
          emacs-overlay.overlay
          nix-index-database.overlays.nix-index
          nur.overlays.default
          gnome-mobile.overlays.default
          nix-software-center.overlay
          nix-minecraft.overlay
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

      hmModuleConfig = system: {
        home-manager = {
          pkgs = import nixpkgs {
            inherit system;
            config = nixpkgsConfig.config;
            overlays = nixpkgsConfig.overlays;
          };
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
          sharedModules = [ ] ++ hmModules;
          extraSpecialArgs = (commonSpecialArgs system);
        };
      };

      # creates a list of all the modules, e.g. [ ./modules/dunst.nix ./modules/emacs.nix etc... ]
      hmModules = with builtins; [
        declarative-cachix.homeManagerModules.declarative-cachix-experimental
        impermanence.nixosModules.home-manager.impermanence
        nix-index-database.homeModules.nix-index
        nixConfig
        agenix.homeManagerModules.default
        spicetify-nix.homeManagerModules.default
        # ./secrets/default.nix
      ] ++ (map (n: "${./modules/home-manager}/${n}") (filter (name: nixpkgs.lib.hasSuffix ".nix" name) (attrNames (readDir ./modules/home-manager))));
      darwinModules = system: [
        home-manager.darwinModules.home-manager
        agenix.darwinModules.default
        (hmModuleConfig system)
        # ./secrets/default.nix
      ] ++ map (n: "${./modules/darwin}/${n}") (builtins.attrNames (builtins.readDir ./modules/darwin));
      nixosModules = system: [
        disko.nixosModules.disko
        declarative-cachix.nixosModules.declarative-cachix
        chaotic.nixosModules.default
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
        nix-minecraft.nixosModules.minecraft-servers
        (hmModuleConfig system)
        { nixpkgs = nixpkgsConfig; }
        # ./secrets/default.nix
      ] ++ map (n: "${./modules/nixos}/${n}") (builtins.attrNames (builtins.readDir ./modules/nixos));

      nixpkgs-patched = with self.nixpkgs; applyPatches {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        patches = [
          # example
          # # https://github.com/NixOS/nixpkgs/pull/354969
          # (fetchpatch {
          #   name = "ollama: 0.3.12 -> 0.4.1";
          #   url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/354969.patch";
          #   hash = "sha256-pehGTyLWQ6pxsEvNRIuRc+gtGvF7cUcP9md9G+osw3g=";
          # })
          # (fetchpatch {
          #   name = "vaultwarden: 1.34.1 -> 1.34.3; vaultwarden.webvault: 2025.5.0.0 -> 2025.7.0.0";
          #   url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/429138.patch";
          #   hash = "sha256-3sR1dOCbEAvOtTp4yWDzOsyu1Fq70CdhMZdOSO+6zUI=";
          # })
        ];
      };

      commonSpecialArgs = system: {
        inherit myLib;
        inherit inputs;
        inherit nixpkgs;
        rootPath = ./.;
        pkgs-patched = import nixpkgs-patched {
          system = "x86_64-linux";
          config = nixpkgsConfig.config;
          overlays = nixpkgsConfig.overlays;
        };
        pkgs-stable = import nixpkgs-stable {
          system = "x86_64-linux";
          config = nixpkgsConfig.config;
          overlays = nixpkgsConfig.overlays;
        };
        pkgs-23_11 = import nixpkgs-23_11 {
          system = "x86_64-linux";
          config = nixpkgsConfig.config;
          overlays = nixpkgsConfig.overlays;
        };
      };

      # System types to support.
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        config = nixpkgsConfig.config;
        overlays = nixpkgsConfig.overlays;
      });
    in
    {
      homeConfigurations = {
        pablo = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgsFor.x86_64-linux;
          extraSpecialArgs = (commonSpecialArgs "x86_64-linux");
          modules = [
            ./hosts/t14s/home.nix
          ] ++ hmModules;
        };
        deck = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgsFor.x86_64-linux;
          extraSpecialArgs = (commonSpecialArgs "x86_64-linux");
          modules = [
            ./hosts/deck/home.nix
          ] ++ hmModules;
        };
      };
      darwinConfigurations.FQ3VX4RWV4 = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = (commonSpecialArgs system);
        modules = (darwinModules system) ++ [
          ./hosts/darwin/nix-darwin.nix
          {
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
      };
      nixOnDroidConfigurations = {
        default = nix-on-droid.lib.nixOnDroidConfiguration {
          modules = [
            ./hosts/sm-f936b/nix-on-droid.nix
            {
              home-manager.config = { pkgs, ... }: {
                imports = [ ./hosts/sm-f936b/home.nix ];
              };
            }
          ] ++ (hmModuleConfig "aarch64-linux");
          extraSpecialArgs = (commonSpecialArgs "aarch64-linux");
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
      nixosConfigurations.rpi = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        modules = (nixosModules system) ++ [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./hosts/rpi/nixos.nix
          {
            home-manager.users.pablo = { pkgs, ... }: {
              imports = [ ./hosts/rpi/home.nix ];
            };
            config = {
              # Disable zstd compression
              sdImage.compressImage = false;
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
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = (commonSpecialArgs system);
        modules = (nixosModules system) ++ [
          ./hosts/server/nixos.nix
          {
            home-manager.users.pablo = { pkgs, ... }: {
              imports = [ ./hosts/server/home.nix ];
            };
            home-manager.users.root = { pkgs, ... }: {
              imports = [ ./hosts/server/root-home.nix ];
            };
          }
        ];
      };
      nixosConfigurations.enchilada = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        modules = (nixosModules system) ++ [
          (import "${mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })
          gnome-mobile.nixosModules.gnome-mobile
          ./hosts/enchilada/nixos.nix
          {
            home-manager.users.pablo = { pkgs, ... }: {
              imports = [ ./hosts/rpi/home.nix ];
            };
          }
        ];
        specialArgs = (commonSpecialArgs system);
      };
      devShell = myLib.forAllSystems (system:
        let
          pkgs = myLib.nixpkgsFor.${system};
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            # just
            # rpiboot
            nixos-rebuild
            # agenix.packages.${system}.default
          ];
        }
      );
      templates = {
        default = {
          description = "My flake template";
          path = ./template/default;
        };
        python = {
          description = "Python and Latex devenv template";
          path = ./template/python;
        };
      };
      nixpkgs = import nixpkgs {
        system = "x86_64-linux";
        config = nixpkgsConfig.config;
        overlays = nixpkgsConfig.overlays;
      };

      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = (inputs.nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [ ./packages/nvf.nix ];
          }).neovim;
        }
      ) // {
        "aarch64-linux" = {
          enchilada-mobile-images = self.nixosConfigurations.enchilada.config.mobile.outputs.android.android-fastboot-images;
        };
      };
    };
}
