{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.home-assistant;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.home-assistant = {
    enable = mkEnableOption "home-assistant";
  };

  config = mkIf cfg.enable {
    services = {
      home-assistant = {
        enable = true;
        openFirewall = true;
        group = "arr";
      };
      nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "home-assistant";
            port = "8123";
            extraConfig = ''
              proxy_buffering off;
            '';
          };
    };
  };
}
