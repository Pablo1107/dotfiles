{ config, options, lib, pkgs, myLib, ... }:

with lib;

let
  cfg = config.personal.tmux;
in
{
  options.personal.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      extraConfig = myLib.getDotfile "tmux" ".tmux.conf";
    };
  };
}
