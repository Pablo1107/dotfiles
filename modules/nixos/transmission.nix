{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

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
    };

    users.users.pablo.extraGroups = [ "transmission" ];

    services = {
      jackett = {
        enable = true;
        openFirewall = true;
      };
      radarr = {
        enable = true;
        openFirewall = true;
      };
      bazarr = {
        enable = true;
        openFirewall = true;
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
      };

      nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "transmission";
            port = "9091";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "jackett";
            port = "9117";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "radarr";
            port = "7878";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "bazarr";
            port = "6767";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "prowlarr";
            port = "9696";
          };
    };
  };
}
