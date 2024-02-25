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
    environment.etc."dotfiles/rev".text =
      (builtins.fetchGit { url = ./.; ref = "HEAD"; }).rev;
    environment.etc."dotfiles/src".source = builtins.fetchGit ../../.;
  };
}
