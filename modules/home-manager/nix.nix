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
      trusted-users = [ "${config.home.username}" "@admin" ];
      builders = [ "ssh://root@nixos.local?ssh-key=${config.home.homeDirectory}/.ssh/id_rsa x86_64-linux" ];
      builders-use-substitutes = true;
    };
    nix.package = mkIf (pkgs.stdenv.hostPlatform.isLinux) (mkForce pkgs.nixVersions.nix_2_17);

    caches.cachix = [
      { name = "nix-community"; sha256 = "0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x"; }
      { name = "colmena"; sha256 = "0bp5zpaspxcgk99g1rp5176l6lima09jl3vbbagr8px88sqknnry"; }
    ];
  };
}
