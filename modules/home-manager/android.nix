{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.android;
in
{
  options.personal.android = {
    enable = mkEnableOption "android";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      android-tools
    ];
  };
}
