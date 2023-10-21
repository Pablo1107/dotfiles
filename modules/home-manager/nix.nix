{ config, options, lib, pkgs, ... }:

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
      extra-platforms = [ "aarch64-linux" ];
      trusted-users = [ "pablo" ];
    };
    nix.package = mkIf (pkgs.stdenv.hostPlatform.isLinux) (mkForce pkgs.nix);

    caches.cachix = [
      { name = "nix-community"; sha256 = "0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x"; }
    ];
  };
}
