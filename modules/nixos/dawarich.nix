{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.dawarich;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.dawarich = {
    enable = mkEnableOption "dawarich";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts =
      createVirtualHosts
        {
          inherit nginxCfg;
          subdomain = "dawarich";
          port = "2284";
        };

    personal.docker-compose.dawarich = {
      stateDirectory.enable = true;

      file = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Freika/dawarich/refs/tags/0.22.1/docker/docker-compose.yml";
        hash = "sha256-gbhYZ3gqDHwszjtT2eOFS9dPybpknrQQb76m2iR1gSw=";
      };

      override = {
        services = {
          dawarich_app = {
            ports = [
              "2284:3000"
            ];
            environment = {
              APPLICATION_HOST = "dawarich.${nginxCfg.localDomain}";
              APPLICATION_HOSTS = "dawarich.${nginxCfg.localDomain},127.0.0.1";
            };
          };
          dawarich_sidekiq = {
            environment = {
              APPLICATION_HOST = "dawarich.${nginxCfg.localDomain}";
              APPLICATION_HOSTS = "dawarich.${nginxCfg.localDomain},127.0.0.1";
            };
          };
        };
        volumes = {
          dawarich_db_data = {
            driver = "local";
            driver_opts = {
              type = "none";
              o = "bind";
              device = "/var/lib/dawarich/db_data";
            };
          };
          dawarich_shared = {
            driver = "local";
            driver_opts = {
              type = "none";
              o = "bind";
              device = "/var/lib/dawarich/shared_data";
            };
          };
          dawarich_public = {
            driver = "local";
            driver_opts = {
              type = "none";
              o = "bind";
              device = "/var/lib/dawarich/public";
            };
          };
          dawarich_watched = {
            driver = "local";
            driver_opts = {
              type = "none";
              o = "bind";
              device = "/var/lib/dawarich/watched";
            };
          };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/dawarich/db_data 0755 root root -"
      "d /var/lib/dawarich/gem_cache 0755 root root -"
      "d /var/lib/dawarich/shared_data 0755 root root -"
      "d /var/lib/dawarich/public 0755 root root -"
      "d /var/lib/dawarich/watched 0755 root root -"
    ];
  };
}
