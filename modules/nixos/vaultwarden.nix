{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.vaultwarden;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.vaultwarden = {
    enable = mkEnableOption "vaultwarden";
  };

  config = mkIf cfg.enable {
    services = {
      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
        environmentFile = "/etc/vaultwarden/envs";
        config = {
          DOMAIN = "https://bitwarden." + nginxCfg.localDomain;
          SIGNUPS_ALLOWED = true;

          # Vaultwarden currently recommends running behind a reverse proxy
          # (nginx or similar) for TLS termination, see
          # https://github.com/dani-garcia/vaultwarden/wiki/Hardening-Guide#reverse-proxying
          # > you should avoid enabling HTTPS via vaultwarden's built-in Rocket TLS support,
          # > especially if your instance is publicly accessible.
          #
          # A suitable NixOS nginx reverse proxy example config might be:
          #
          #     services.nginx.virtualHosts."bitwarden.example.com" = {
          #       enableACME = true;
          #       forceSSL = true;
          #       locations."/" = {
          #         proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          #       };
          #     };
          WEBSOCKET_ADDRESS = "127.0.0.1";
          WEBSOCKET_PORT = 3012;
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          ROCKET_LOG = "critical";

          DATABASE_URL = "postgresql://vaultwarden@/vaultwarden";
        };
      };
      nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "bitwarden";
            port = "8222";
            extraLocations = {
              "/notifications/hub" = {
                proxyPass = "http://127.0.0.1:3012";
                proxyWebsockets = true;
              };
              "/notifications/hub/negotiate" = {
                proxyPass = "http://127.0.0.1:8222";
                proxyWebsockets = true;
              };
            };
          };
      postgresql = {
        enable = true;
        ensureDatabases = [ "vaultwarden" ];
        ensureUsers = [
          {
            name = "vaultwarden";
            ensureDBOwnership = true;
          }
        ];
      };
    };
  };
}
