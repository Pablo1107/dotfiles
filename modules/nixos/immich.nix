{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.immich;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.immich = {
    enable = mkEnableOption "immich";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts =
      createVirtualHosts
        {
          inherit nginxCfg;
          subdomain = "immich";
          port = "2283";
        };

    # https://github.com/Atemu/nixos-config/blob/d6a173bcf9c28f2b161f0b238baa0e9c62be2b7b/modules/immich/module.nix
    personal.docker-compose.immich = {
      stateDirectory.enable = true;

      env = {
        # You can find documentation for all the supported env variables at https://immich.app/docs/install/environment-variables

        # The location where your uploaded files are stored
        UPLOAD_LOCATION = "/var/lib/immich/"; # The systemd StateDirectory

        # The Immich version to use. You can pin this to a specific version like "v1.71.0"
        IMMICH_VERSION = "release";

        # Connection secret for postgres. You should change it to a random password
        DB_PASSWORD = "postgres";

        # The values below this line do not need to be changed
        ###################################################################################
        DB_HOSTNAME = "immich_postgres";
        DB_USERNAME = "postgres";
        DB_DATABASE_NAME = "immich";

        REDIS_HOSTNAME = "immich_redis";
      };

      file = pkgs.fetchurl {
        url = "https://github.com/immich-app/immich/releases/download/v1.97.0/docker-compose.yml";
        hash = "sha256-onNPerC2a65Uy6sAXaU6WMhPJOnWOyq3HaTkL2oixx8=";
      };

      override = {
        services.database = {
          volumes = [
            "\${UPLOAD_LOCATION}/pgdata/:/var/lib/postgresql/data"
          ];
        };
      };
    };
  };
}
