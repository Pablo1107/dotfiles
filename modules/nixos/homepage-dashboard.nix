{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.homepage-dashboard;
  nginxCfg = config.personal.reverse-proxy;
in {
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
        bookmarks = [
          {
            Developer = [{
              Github = [{
                abbr = "GH";
                href = "https://github.com/";
              }];
            }];
          }
          {
            Entertainment = [{
              YouTube = [{
                abbr = "YT";
                href = "https://youtube.com/";
              }];
            }];
          }
        ];
        services = [
          {
            "Media" = [
              {
                "Jellyfin" = {
                  description = "Jellyfin - A self-hosted media server";
                  href = "https://jellyfin.${nginxCfg.localDomain}";
                };
              }
              {
                "Jellyseerr" = {
                  description = "Jellyseerr - Media request management";
                  href = "https://jellyseerr.${nginxCfg.localDomain}";
                };
              }
              {
                "Prowlarr" = {
                  description = "Prowlarr - Indexer manager for media apps";
                  href = "https://prowlarr.${nginxCfg.localDomain}";
                };
              }
              {
                "Radarr" = {
                  description = "Radarr - Movie collection manager";
                  href = "https://radarr.${nginxCfg.localDomain}";
                };
              }
              {
                "Sonarr" = {
                  description = "Sonarr - TV show collection manager";
                  href = "https://sonarr.${nginxCfg.localDomain}";
                };
              }
              {
                "Transmission" = {
                  description = "Transmission - Torrent client";
                  href = "https://transmission.${nginxCfg.localDomain}";
                };
              }
            ];
          }
          {
            "Productivity" = [
              {
                "Bitwarden" = {
                  description = "Bitwarden - Password manager";
                  href = "https://bitwarden.${nginxCfg.localDomain}";
                };
              }
              {
                "Grocy" = {
                  description =
                    "Grocy - ERP system for groceries and household";
                  href = "https://grocy.${nginxCfg.localDomain}";
                };
              }
              {
                "Homepage" = {
                  description = "Homepage - A self-hosted dashboard";
                  href = "https://homepage.${nginxCfg.localDomain}";
                };
              }
              {
                "Classquiz" = {
                  description = "Classquiz - Quiz application";
                  href = "https://classquiz.${nginxCfg.localDomain}";
                };
              }
              {
                "ILV Map" = {
                  description = "ILV Map - Interactive map service";
                  href = "https://ilvmap.${nginxCfg.localDomain}";
                };
              }
              {
                "Immich" = {
                  description = "Immich - Media backup service";
                  href = "https://immich.${nginxCfg.localDomain}";
                };
              }
            ];
          }
          {
            "Utility" = [
              {
                "Cockpit" = {
                  description = "Cockpit - Server management";
                  href = "https://cockpit.${nginxCfg.localDomain}";
                };
              }
              {
                "Syncthing" = {
                  description = "Syncthing - File synchronization";
                  href = "https://syncthing.${nginxCfg.localDomain}";
                };
              }
            ];
          }
        ];
        widgets = [
          {
            resources = {
              cpu = true;
              disk = "/";
              memory = true;
            };
          }
          {
            search = {
              provider = "duckduckgo";
              target = "_blank";
            };
          }
        ];
      };

      nginx.virtualHosts = createVirtualHosts {
        inherit nginxCfg;
        subdomain = "homepage";
        port = "8082";
      };
    };
  };
}
