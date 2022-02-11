{
  description = "A Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = inputs: {
    homeConfigurations = {
      pablo = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/pablo";
        username = "pablo";
        stateVersion = "21.05";
        configuration = {
          imports = [ ./config/nixpkgs/home.nix ];
          nixpkgs = {
            config = { allowUnfree = true; };
            overlays = [ inputs.nur.overlay inputs.nixgl.overlay ];
          };
        };
      };
    };
  };
}
