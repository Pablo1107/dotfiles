{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.uptime-kuma;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.uptime-kuma = {
    enable = mkEnableOption "uptime-kuma";
  };

  config = mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings = {
        PORT = "5436";
      };
    };

    services.nginx.virtualHosts =
      createVirtualHosts
        {
          inherit nginxCfg;
          subdomain = "uptime";
          port = "5436";
        };
  };
}
