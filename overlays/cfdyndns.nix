self: pkgs:

with pkgs;

{
  cfdyndns = cfdyndns.override {
    rustPlatform.buildRustPackage = attrs: let
      attrs' = builtins.removeAttrs attrs ["cargoHash"];

      overrideAttrs = {
        cargoPatches = [
          ./cfdyndns/patch.diff
        ];
        cargoLock = {
          lockFile = ./cfdyndns/Cargo.lock;
          outputHashes."cloudflare-0.12.0" = "sha256-npT4S1epHABaOeNBA0y2ydeuDtqKG7KX2PVOY25XWpU=";
          outputHashes."public-ip-0.2.2" = "sha256-DDdh90EAo3Ppsym4AntczFuiAQo4/QQ9TEPJjMB1XzY=";
        };
      };
    in
      self.rustPlatform.buildRustPackage (attrs' // overrideAttrs);
  };
}
