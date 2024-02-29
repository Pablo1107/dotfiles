{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.transmission;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.transmission = {
    enable = mkEnableOption "transmission";
  };

  config = mkIf cfg.enable {
    services = {
      transmission = {
        enable = true; #Enable transmission daemon
        openRPCPort = true; #Open firewall for RPC
        settings = {
          rpc-authentication-required = false;
          rpc-bind-address = "0.0.0.0";
          rpc-host-whitelist-enabled = false;
          rpc-whitelist-enabled = false;
          rpc-port = 9091;
        };
      };
      nginx.virtualHosts = {
        "transmission.${nginxCfg.publicDomain}" = {
          useACMEHost = nginxCfg.localDomain;
          forceSSL = true;
          enableACME = false;
          http2 = true;
          locations."/" = {
            proxyPass = "http://nixos.local:9091";
            proxyWebsockets = true;
          };
        };
        "transmission.${nginxCfg.localDomain}" = {
          useACMEHost = nginxCfg.localDomain;
          forceSSL = true;
          enableACME = false;
          http2 = true;
          locations."/" = {
            proxyPass = "http://nixos.local:9091";
            proxyWebsockets = true;
          };
        };
      };
    };

    users.users.pablo.extraGroups = [ "transmission" ];
  };
}
