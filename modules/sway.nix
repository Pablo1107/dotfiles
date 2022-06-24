{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.sway;
in
{
  options.personal.sway = {
    enable = mkEnableOption "sway";
  };

  config = mkIf cfg.enable {
    # sway installed on arch linux
    home.packages = with pkgs; [
      brillo
    ];
  };
}
