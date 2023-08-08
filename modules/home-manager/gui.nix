{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.gui;
in
{
  options.personal.gui = {
    enable = mkEnableOption "gui";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (myLib.nixGLWrapper pkgs {
        bin = "alacritty";
        package = alacritty;
      })
      (myLib.nixGLWrapper pkgs {
        bin = "foot";
        package = foot;
      })
    ];
  };
}
