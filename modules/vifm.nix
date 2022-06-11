{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.vifm;
in
{
  options.personal.vifm = {
    enable = mkEnableOption "vifm";
  };

  config = mkIf cfg.enable {
    home.file.".config/vifm/vifmrc".text = myLib.getDotfile "vifm" "vifmrc";
    # home.file.".config/vifm/colors/solarized-dark.vifm".text = getDotfile "vifm" "colors/solarized-dark.vifm";
  };
}
