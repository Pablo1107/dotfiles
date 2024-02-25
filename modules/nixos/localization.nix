{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.localization;
in
{
  options.personal.localization = {
    enable = mkEnableOption "localization";
  };

  config = mkIf cfg.enable {
    time.timeZone = "America/Argentina/Buenos_Aires";
    i18n.defaultLocale = "en_US.UTF-8";
    # defined in another place?
    # console.keyMap = "us";
  };
}
