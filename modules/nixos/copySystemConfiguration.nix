{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.copySystemConfiguration;
in
{
  options.personal.copySystemConfiguration = {
    enable = mkEnableOption "copySystemConfiguration";
  };

  config = mkIf cfg.enable {
    # https://discourse.nixos.org/t/is-it-possible-to-recover-configuration-nix-from-an-older-generation/2659/9
    # environment.etc."dotfiles/rev".text =
    #   (builtins.fetchGit { url = ./.; ref = "HEAD"; }).rev;
    # https://github.com/NixOS/nix/issues/9292
    # environment.etc."dotfiles/src".source = builtins.fetchGit ../../.;
  };
}
