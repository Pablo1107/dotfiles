{
  allowUnfree = true;
  packageOverrides = pkgs: {
    nur = import (
      builtins.fetchTarball {
        # Get the revision by choosing a version from https://github.com/nix-community/NUR/commits/master
        url = "https://github.com/nix-community/NUR/archive/73fc4ff8f984dcf229d8390fb09bc61494c134db.tar.gz";
        # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
        sha256 = "1rkpjrm8mv8s8hz828l04smdp3q3pjy2804fymksyqnay5biddrd";
      }
    ) {
      inherit pkgs;
    };
  };
}
