{ config, options, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.personal.nix;
in
{
  options.personal.nix = {
    enable = mkEnableOption "nix";
  };

  config = mkIf cfg.enable {
    # not using this because of declarative-cachix
    # https://github.com/jonascarpay/declarative-cachix#warning
    # home.file.nixConf.text = ''
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      tarball-ttl = 86400;
      warn-dirty = false;
      keep-derivations = true;
      keep-outputs = true;
      extra-platforms = [ "aarch64-linux" "i686-linux" ];
      trusted-users = [ "${config.home.username}" "@admin" ];
      # builders = [ "ssh://root@nixos.local?ssh-key=${config.home.homeDirectory}/.ssh/id_rsa x86_64-linux" ];
      # builders-use-substitutes = true;

      # some issue with downloading cache binaries
      # https://github.com/NixOS/nix/issues/11352#issuecomment-2608698554
      http2 = false;
    };
    nix.package = mkIf (pkgs.stdenv.hostPlatform.isLinux) (mkForce pkgs.nix);

    nix.registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;

    caches.cachix = [
      { name = "nix-community"; sha256 = "0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x"; }
      { name = "colmena"; sha256 = "0bp5zpaspxcgk99g1rp5176l6lima09jl3vbbagr8px88sqknnry"; }
      { name = "devenv"; sha256 = "1wkgb3igqjp7x5x9bg3dz3c368mxlch3v665kynfj9c4l633llwj"; }
    ];
  };
}
