{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.gatus;
  nginxCfg = config.personal.reverse-proxy;
  port = "2284";
in
{
  options.personal.gatus = {
    enable = mkEnableOption "gatus";
  };

  config = mkIf cfg.enable {
    services.gatus = {
      enable = true;
      openFirewall = true;
      settings.web.port = toInt port;
    };

    services.nginx.virtualHosts =
      createVirtualHosts
        {
          inherit nginxCfg port;
          subdomain = "gatus";
        };
  };
}
