{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.nh;
in
{
  options.personal.nh = {
    enable = mkEnableOption "nh";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = config.users.users.pablo.home + "/dotfiles";
    };
  };
}