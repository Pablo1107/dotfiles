{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.npm;
in
{
  options.personal.npm = {
    enable = mkEnableOption "npm";
  };

  config = mkIf cfg.enable {
    home.file.".npmrc".text = ''
      prefix=~/.local
    '';
    home.sessionPath = [
      "$HOME/.local/bin"
    ];
  };
}
