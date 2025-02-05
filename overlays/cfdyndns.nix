self: pkgs:

with pkgs;

{
  cfdyndns = cfdyndns.override {
    rustPlatform.buildRustPackage = attrs: let
      attrs' = builtins.removeAttrs attrs ["cargoHash"];

      overrideAttrs = {
        src = fetchFromGitHub {
          owner = "Pablo1107";
          repo = "cfdyndns";
          rev = "update-cloudflare-rs-to-0.13";
          sha256 = "sha256-IYhaN3dwkNEs4NOWvMpyKnnKOXElTLUf7yy+Ya0AAvs=";
        };
        cargoLock = {
          lockFile = ./cfdyndns/Cargo.lock;
          # outputHashes."cloudflare-0.13.0" = "sha256-L7funou+PBMIwmZEkIyZNuAzmFAWgBS3PGgxOnj+aIQ=";
          outputHashes."public-ip-0.2.2" = "sha256-DDdh90EAo3Ppsym4AntczFuiAQo4/QQ9TEPJjMB1XzY=";
        };
      };
    in
      self.rustPlatform.buildRustPackage (attrs' // overrideAttrs);
  };
}
