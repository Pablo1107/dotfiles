{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.homepage-dashboard;
in
{
  options.personal.homepage-dashboard = {
    enable = mkEnableOption "homepage-dashboard";
  };

  config = mkIf cfg.enable {
    services = {
      homepage-dashboard = {
        enable = true;
        # package = ;
        openFirewall = true;
        listenPort = 8082;
      };
    };
  };
}
