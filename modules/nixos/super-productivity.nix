{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

with lib;
with myLib;

let
  cfg = config.personal.super-productivity;
  nginxCfg = config.personal.reverse-proxy;
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
          };

    virtualisation.oci-containers.containers = {
      # Super-Productivity service
      super-productivity = {
        image = "johannesjo/super-productivity:v14.0.3";
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
    };

    # Ensure the state directory exists
    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0755 root root -"
      "f ${cfg.stateDir}/webdav/config.yaml 0644 root root - - -"
      "d ${cfg.stateDir}/webdav/data 0755 root root -"
      "d ${cfg.stateDir}/webdav/sync 0755 root root -"
    ];
  };
}
