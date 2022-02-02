{
  allowUnfree = true;
  packageOverrides = pkgs: {
    nur = import
      (
        builtins.fetchTarball {
          # Get the revision by choosing a version from https://github.com/nix-community/NUR/commits/master
          url = "https://github.com/nix-community/NUR/archive/fc0758e2f8aa4dac7c4ab42860f07487b1dcadea.tar.gz";
          # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
          sha256 = "162z0yfw1hdw8700qns5k7b6klv0c190s0f66c7hgi9zhswz8d8s";
        }
      )
      {
        inherit pkgs;
      };
  };
}
