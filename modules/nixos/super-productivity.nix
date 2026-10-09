{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

with lib;
with myLib;

let
  cfg = config.personal.super-productivity;
  nginxCfg = config.personal.reverse-proxy;

  supersyncEnvFile = "/etc/supersync/supersync.env";
  supersyncDbPasswordFile = "/etc/supersync/db-password";
in
{
  options.personal.super-productivity = {
    enable = mkEnableOption "super-productivity";

    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/super-productivity";
      description = "Directory to store Super-Productivity data.";
    };

    webdavBaseUrl = mkOption {
      type = types.nullOr types.str;
      # default = "https://sp-webdav." + nginxCfg.localDomain;
      default = "https://super-productivity." + nginxCfg.localDomain + "/webdav/";
      description = "Base URL for the WebDAV backend (e.g., https://webdav.example.com).";
    };

    webdavUsername = mkOption {
      type = types.nullOr types.str;
      default = "pablo";
      description = "Username for the WebDAV backend.";
    };

    webdavSyncFolderPath = mkOption {
      type = types.nullOr types.str;
      default = "/super-productivity/";
      description = "Path to the sync folder in the WebDAV backend.";
    };

    syncInterval = mkOption {
      type = types.nullOr types.int;
      default = 60;
      description = "Sync interval in seconds (default is 60 seconds).";
    };

    enableCompression = mkOption {
      type = types.nullOr types.bool;
      default = false;
      description = "Enable compression for the WebDAV backend.";
    };

    enableEncryption = mkOption {
      type = types.nullOr types.bool;
      default = false;
      description = "Enable encryption for the WebDAV backend.";
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "super-productivity";
            port = "7001";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "sp-webdav";
            port = "7002";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "supersync";
            port = "7003";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "mailpit";
            port = "7004";
          };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "supersync" ];
      ensureUsers = [
        {
          name = "supersync";
          ensureDBOwnership = true;
        }
      ];
      authentication = ''
        local supersync supersync scram-sha-256
      '';
    };

    systemd.services.postgresql-setup.script = mkAfter ''
      if [ -r ${supersyncDbPasswordFile} ]; then
        psql -d postgres -v ON_ERROR_STOP=1 <<'EOF'
      \set pw `cat ${supersyncDbPasswordFile}`
      ALTER ROLE supersync WITH PASSWORD :'pw';
      EOF
      else
        echo "warning: ${supersyncDbPasswordFile} is missing, supersync role has no password"
      fi
    '';

    systemd.services."${config.virtualisation.oci-containers.backend}-supersync" = {
      requires = [ "postgresql.service" "postgresql-setup.service" ];
      after = [ "postgresql.service" "postgresql-setup.service" ];
    };

    virtualisation.oci-containers = {
      backend = "podman";

      containers = {
        # Super-Productivity service
        super-productivity = {
          image = "johannesjo/super-productivity:v19.1.0";
          ports = [ "7001:80" ];
          environment = {
            # WebDAV backend served at `/webdav/` subdirectory (Optional)
            WEBDAV_BACKEND = "http://webdav";
            # Default values in "Sync" section in "Settings" page (Optional)
            WEBDAV_BASE_URL       = cfg.webdavBaseUrl;
            WEBDAV_USERNAME       = cfg.webdavUsername;
            WEBDAV_SYNC_FOLDER_PATH = cfg.webdavSyncFolderPath;
            SYNC_INTERVAL         = toString cfg.syncInterval;
            IS_COMPRESSION_ENABLED = toString cfg.enableCompression;
            IS_ENCRYPTION_ENABLED  = toString cfg.enableEncryption;
          };
        };

        # WebDAV backend container
        webdav = {
          image = "hacdias/webdav:latest";
          ports = [ "7002:80" ];
          volumes = [
            # Mount config and data directories
            "${toString cfg.stateDir}/webdav/config.yaml:/config.yml:ro"
            "${toString cfg.stateDir}/webdav/data:/data"
          ];
        };

        # SuperSync server, keep the version in sync with super-productivity
        supersync = {
          image = "ghcr.io/warreth/super-sync-server:v19.1.0";
          ports = [ "127.0.0.1:7003:1900" ];
          environment = {
            PUBLIC_URL = "https://supersync.${nginxCfg.localDomain}";
            CORS_ORIGINS = "https://super-productivity.${nginxCfg.localDomain},https://app.super-productivity.com";
            WEBAUTHN_RP_ID = "supersync.${nginxCfg.localDomain}";
            WEBAUTHN_ORIGIN = "https://supersync.${nginxCfg.localDomain}";
            WEBAUTHN_RP_NAME = "SuperSync";
            # No separate migration step outside of upstream's compose deploy
            RUN_MIGRATIONS_ON_STARTUP = "true";
            REQUIRE_DATABASE_POOL_LIMITS = "true";

            # Mailpit
            SMTP_HOST = "127.0.0.1";
            SMTP_PORT = "1025";
          };
          # JWT_SECRET and DATABASE_URL, see supersyncEnvFile
          environmentFiles = [ supersyncEnvFile ];
          volumes = [
            "${toString cfg.stateDir}/supersync/data:/app/data"
            "/run/postgresql:/run/postgresql"
          ];
          extraOptions = [
            "--init"
            "--cap-drop=ALL"
            "--security-opt=no-new-privileges"
            "--memory=768m"
          ];
        };
      };
    };

    services.mailpit.instances.default = {
      smtp = "0.0.0.0:1025";
      listen = "0.0.0.0:7004";
    }; # for mf supersync

    # Ensure the state directory exists
    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0755 root root -"
      "f ${cfg.stateDir}/webdav/config.yaml 0644 root root - - -"
      "d ${cfg.stateDir}/webdav/data 0755 root root -"
      "d ${cfg.stateDir}/webdav/sync 0755 root root -"
      "d ${cfg.stateDir}/supersync 0755 root root -"
      "d ${cfg.stateDir}/supersync/data 0750 1001 1001 -"
    ];
  };
}
