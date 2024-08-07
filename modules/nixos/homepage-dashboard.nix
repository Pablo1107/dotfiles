{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.homepage-dashboard;
  nginxCfg = config.personal.reverse-proxy;
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
        # config in /var/lib/homepage-dashboard
      };

      nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "homepage";
            port = "8082";
          };
    };
  };
}
