self: super:
{
  vifm = super.vifm.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "vifm";
      repo = "vifm";
      rev = "515b837e3f32b97592afc05bb5c7f5ae7c2636c4";
      # If you don't know the hash, the first time, set:
      # sha256 = "0000000000000000000000000000000000000000000000000000";
      # then nix will fail the build with such an error message:
      # hash mismatch in fixed-output derivation '/nix/store/m1ga09c0z1a6n7rj8ky3s31dpgalsn0n-source':
      # wanted: sha256:0000000000000000000000000000000000000000000000000000
      # got:    sha256:173gxk0ymiw94glyjzjizp8bv8g72gwkjhacigd1an09jshdrjb4
      sha256 = "sha256-mbU9Y29RbwFd0/WlQHNynUHkGgXTCJeWpPMmzyJQuzU=";
    };
  });
}

