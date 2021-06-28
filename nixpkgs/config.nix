{
  allowUnfree = true;
  packageOverrides = pkgs: {
    nur = import (
      builtins.fetchTarball {
        # Get the revision by choosing a version from https://github.com/nix-community/NUR/commits/master
        url = "https://github.com/nix-community/NUR/archive/5d143233e53065486c9a768c93bafbc61a1261e1.tar.gz";
        # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
        sha256 = "055vp8025w71qbcbj9djr6x8znl73d35pkf2v52j38zd2z6mb32w";
      }
    ) {
      inherit pkgs;
    };
  };
}
