{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.adventurelog;
  nginxCfg = config.personal.reverse-proxy;
  alCfg = config.services.adventurelog;

  frontendHost = "adventurelog.${nginxCfg.localDomain}";
  backendHost = "adventurelog-api.${nginxCfg.localDomain}";
in
{
  options.personal.adventurelog = {
    enable = mkEnableOption "adventurelog";
  };

  config = mkIf cfg.enable {
    services.adventurelog = {
      enable = true;
      backend = {
        enable = true;
        host = "127.0.0.1";
        port = 2000;
        publicUrl = "https://${backendHost}";
        frontendUrl = "https://${frontendHost}";
        # Contains DJANGO_ADMIN_USERNAME, DJANGO_ADMIN_PASSWORD and DJANGO_ADMIN_EMAIL.
        # Create it by hand, it is kept out of the store.
        admin.envFile = "/etc/adventurelog/admin.env";
      };
      frontend = {
        enable = true;
        host = "127.0.0.1";
        port = 2104;
        origin = "https://${frontendHost}";
        publicServerUrl = "https://${backendHost}";
      };
      database.createLocally = true;
      # the vhosts are defined below to go through the shared reverse proxy
      nginx.enable = false;
    };

    # the adventurelog module sets a mkDefault postgresql_16, which clashes with
    # the stateVersion default; keep the major version the existing data uses
    services.postgresql.package = pkgs.postgresql_15;
    # the adventurelog module also mkForces the extension list to just postgis,
    # dropping immich's, while its shared_preload_libraries still wants vchord.so.
    # Same priority, so the lists merge.
    services.postgresql.extensions = mkIf config.services.immich.enable (mkForce (ps: [
      ps.pgvector
      ps.vectorchord
    ]));

    services.nginx.virtualHosts =
      (createVirtualHosts {
        inherit nginxCfg;
        subdomain = "adventurelog";
        port = toString alCfg.frontend.port;
      })
      // (createVirtualHosts {
        inherit nginxCfg;
        subdomain = "adventurelog-api";
        port = toString alCfg.backend.port;
        extraConfig = ''
          client_max_body_size ${alCfg.nginx.clientMaxBodySize};
        '';
        extraLocations = {
          "/static/".alias = "${alCfg.backend.staticDir}/";
          "/protectedMedia/" = {
            alias = "${alCfg.dataDir}/media/";
            extraConfig = ''
              internal;
              try_files $uri =404;
            '';
          };
        };
      });

    services.gatus.settings.endpoints = [{
      name = "AdventureLog";
      url = "https://${frontendHost}";
      interval = "5m";
      conditions = [
        "[STATUS] == 200"
        "[RESPONSE_TIME] < 300"
      ];
    }];
  };
}
