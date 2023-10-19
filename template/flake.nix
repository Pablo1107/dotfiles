{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # System types to support.
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      devShell = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
          ];
          shellHook = ''
          '';
        }
      );
    };
}
