{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.photoprism;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.photoprism = {
    enable = mkEnableOption "photoprism";
  };

  config = mkIf cfg.enable {
    services = {
      photoprism = {
        enable = true;
        port = 2342;
        originalsPath = "/var/lib/private/photoprism/originals";
        # importPath = "/home/pablo/Android/Camera";
        address = "0.0.0.0";
        settings = {
          PHOTOPRISM_ADMIN_USER = "admin";
          PHOTOPRISM_ADMIN_PASSWORD = "admin";
          PHOTOPRISM_DEFAULT_LOCALE = "en";
          PHOTOPRISM_DATABASE_DRIVER = "mariadb";
          PHOTOPRISM_DATABASE_NAME = "photoprism";
          PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
          PHOTOPRISM_DATABASE_USER = "photoprism";
          # PHOTOPRISM_SITE_URL = "http://sub.domain.tld:2342";
          PHOTOPRISM_SITE_TITLE = "My PhotoPrism";
        };
      };
      mysql = {
        enable = true;
        # dataDir = "/data/mysql";
        package = pkgs.mariadb;
        ensureDatabases = [ "photoprism" ];
        ensureUsers = [{
          name = "photoprism";
          ensurePermissions = {
            "photoprism.*" = "ALL PRIVILEGES";
          };
        }];
      };
      nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "photoprism";
            port = "2342";
          };
      gatus.settings.endpoints = [{
        name = "PhotoPrism";
        url = "https://photoprism." + nginxCfg.localDomain;
        interval = "5m";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 300"
        ];
      }];
    };

    fileSystems."/var/lib/private/photoprism/originals/Android" = {
      device = "/home/pablo/Android/Camera";
      options = [ "bind" ];
    };
  };
}
