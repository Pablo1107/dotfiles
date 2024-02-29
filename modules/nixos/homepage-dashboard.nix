{ config, options, lib, pkgs, ... }:

with lib;

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
      };

      nginx.virtualHosts = {
        "${nginxCfg.publicDomain}" = {
          forceSSL = true;
          enableACME = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://nixos.local:8082";
            proxyWebsockets = true;
          };
        };
        "${nginxCfg.localDomain}" = {
          forceSSL = true;
          enableACME = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://nixos.local:8082";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
