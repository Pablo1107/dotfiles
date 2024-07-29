{ config, options, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.personal.reverse-proxy;
in
{
  options.personal.reverse-proxy = {
    enable = mkEnableOption "reverse-proxy";

    publicDomain = mkOption {
      type = types.str;
      default = inputs.secrets.domains."67c831ed-46e1-4d39-ae12-e9d624fb35db";
    };

    localDomain = mkOption {
      type = types.str;
      default = inputs.secrets.domains."4a6f01f1-6768-4f66-8af9-f43697811d73";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "0";

      # virtualHosts configured on each service module
      # virtualHosts."nixos.local" = {
      #   forceSSL = false;
      #   enableACME = false;
      #   http2 = true;
      #   locations."/" = {
      #     proxyPass = "http://nixos.local:8082";
      #     proxyWebsockets = true;
      #   };
      # };

      virtualHosts."default" = {
        serverAliases = [ "_" ];
        default = true;
        useACMEHost = cfg.localDomain;
        forceSSL = true;
        enableACME = false;
        http2 = true;
        locations."/" = {
          return = "404";
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "dealberapablo07@gmail.com";
      certs = {
        "${cfg.publicDomain}" = {
          domain = cfg.publicDomain;
          dnsProvider = "duckdns";
          environmentFile = "/etc/duckdns-updater/envs";
          webroot = null;
          group = "nginx";
        };
        "${cfg.localDomain}" = {
          domain = cfg.localDomain;
          dnsProvider = "duckdns";
          environmentFile = "/etc/duckdns-updater/envs";
          webroot = null;
          extraDomainNames = [ "*.${cfg.localDomain}" ];
          dnsPropagationCheck = false;
          group = "nginx";
        };
      };
    };
  };
}
