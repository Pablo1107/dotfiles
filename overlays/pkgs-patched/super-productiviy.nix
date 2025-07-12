self: pkgs:

with pkgs;

{
  super-productivity = super-productivity.overrideAttrs (oldAttrs: rec {
    pname = "super-productivity";
    version = "14.0.5";
    src = fetchFromGitHub {
      owner = "johannesjo";
      repo = "super-productivity";
      rev = "v${version}";
      hash = "sha256-SsX9fs8G3z0F0pRkGUfsD0kgEtNGHl0bcRHeeO6Zctc=";
    };

    npmDeps = stdenv.mkDerivation {
      pname = "super-productivity-deps";
      inherit version src;

      nativeBuildInputs = [
        prefetch-npm-deps
        rsync
      ];

      # Some lockfiles do not include any dependencies to install so
      # prefertch-npm-deps produces an error.  Those can be ignored with
      # this flag.
      env.FORCE_EMPTY_CACHE = true;

      buildPhase = ''
        mkdir -p $out
        find -name package-lock.json | while read -r lockfile; do
          prefetch-npm-deps $lockfile /tmp/cache
          # Merge output
          rsync -a /tmp/cache/ $out
          rm -rf /tmp/cache
        done
        # Ensure that the root package-lock.json is placed in the output.
        # This means only the root lockfile is checked for consistancy,
        # but that should not be an issue.
        cp package-lock.json $out
      '';

      dontInstall = true;

      outputHash = "sha256-ECgKJfVZz0PGJVLS2Cb10+lgUVeBvlWsaec5/eztcts=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
  });
}
