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
    # nix.extraOptions = ''
    home.file.nixConf.text = ''
      experimental-features = nix-command flakes
      tarball-ttl = 86400
      warn-dirty = false
      keep-derivations = true
      keep-outputs = true
    '';
  };
}
