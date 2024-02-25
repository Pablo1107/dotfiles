{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.avahi;
in
{
  options.personal.avahi = {
    enable = mkEnableOption "avahi";
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
