{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.emacs;
in
{
  options.personal.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    services.emacs.enable = true;

    # rest of the config is in home manager
  };
}
