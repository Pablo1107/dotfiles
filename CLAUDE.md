# Dotfiles notes

## Updating `packages/more-of-dots.nix`

Bump `version`, then get the new hash (SRI) with:

```sh
nix-prefetch-url https://github.com/aexer0e/more-of-dots/releases/download/v<version>/More.of.Dots_<version>_amd64.AppImage | xargs nix hash to-sri --type sha256
```

(`nix hash convert --hash-algo sha256 --to sri <hash>` is the non-deprecated form of the second step.)

The jailed wrapper lives in `flake.nix` (`packages.more-of-dots`), not in the package file, so a version bump only touches `packages/more-of-dots.nix`.
