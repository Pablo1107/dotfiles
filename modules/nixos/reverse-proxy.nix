{ config, options, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.personal.reverse-proxy;
in
{
  options.personal.reverse-proxy = {
    enable = mkEnableOption "reverse-proxy";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."${inputs.secrets.domains."67c831ed-46e1-4d39-ae12-e9d624fb35db"}" = {
        forceSSL = true;
        enableACME = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://nixos.local:2342";
          proxyWebsockets = true;
        };
      };
      virtualHosts."${inputs.secrets.domains."4a6f01f1-6768-4f66-8af9-f43697811d73"}" = {
        forceSSL = true;
        enableACME = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://nixos.local:2342";
          proxyWebsockets = true;
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "dealberapablo07@gmail.com";
      certs = {
        "${inputs.secrets.domains."67c831ed-46e1-4d39-ae12-e9d624fb35db"}" = {
          domain = inputs.secrets.domains."67c831ed-46e1-4d39-ae12-e9d624fb35db";
          dnsProvider = "duckdns";
          environmentFile = "/etc/duckdns-updater/envs";
          webroot = null;
        };
        "${inputs.secrets.domains."4a6f01f1-6768-4f66-8af9-f43697811d73"}" = {
          domain = inputs.secrets.domains."4a6f01f1-6768-4f66-8af9-f43697811d73";
          dnsProvider = "duckdns";
          environmentFile = "/etc/duckdns-updater/envs";
          webroot = null;
        };
      };
    };
  };
}
