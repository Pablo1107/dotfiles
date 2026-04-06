{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.ups;
in
{
  options.personal.ups = {
    enable = mkEnableOption "UPS monitoring with NUT";
  };

  config = mkIf cfg.enable {
    power.ups = {
      enable = true;
      mode = "standalone";
      ups.primary = {
        description = "Lyonn CTB-1200V";
        driver = "nutdrv_qx";
        port = "auto";
        summary = ''
          default.battery.voltage.low = 24;
          default.battery.voltage.high = 27.4;
        '';
      };
      upsmon = {
        enable = false;
      };
    };
  };
}
