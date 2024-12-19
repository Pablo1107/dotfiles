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
        url = "https://raw.githubusercontent.com/Freika/dawarich/refs/tags/0.18.2/docker-compose.yml";
        hash = "sha256-CHa0gypq8lV7H2bJ1kzDiJGMN8mHlosBFbQNFcFWqFc=";
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
          db_data = {
            driver = "local";
            driver_opts = {
              type = "none";
              o = "bind";
              device = "/var/lib/dawarich/db_data";
            };
          };
          gem_cache = {
            driver = "local";
            driver_opts = {
              type = "none";
              o = "bind";
              device = "/var/lib/dawarich/gem_cache";
            };
          };
          shared_data = {
            driver = "local";
            driver_opts = {
              type = "none";
              o = "bind";
              device = "/var/lib/dawarich/shared_data";
            };
          };
          public = {
            driver = "local";
            driver_opts = {
              type = "none";
              o = "bind";
              device = "/var/lib/dawarich/public";
            };
          };
          watched = {
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