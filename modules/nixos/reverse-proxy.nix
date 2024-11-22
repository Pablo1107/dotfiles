{ config, options, lib, myLib, pkgs, inputs, ... }:

with myLib;
with lib;

let
  cfg = config.personal.reverse-proxy;
  legacyDomain = inputs.secrets.domains."4a6f01f1-6768-4f66-8af9-f43697811d73";
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
      default = inputs.secrets.domains."5ab27717-dffb-4770-a992-7b3681760c2e";
    };

    legacyDomain = mkOption {
      type = types.str;
      default = legacyDomain;
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
        "${legacyDomain}" = {
          domain = legacyDomain;
          dnsProvider = "duckdns";
          environmentFile = "/etc/duckdns-updater/envs";
          webroot = null;
          extraDomainNames = [ "*.${legacyDomain}" ];
          dnsPropagationCheck = false;
          group = "nginx";
        };
        "${cfg.localDomain}" = {
          domain = cfg.localDomain;
          dnsProvider = "cloudflare";
          environmentFile = "/etc/cloudflare.env";
          # webroot = null;
          extraDomainNames = [ "*.${cfg.localDomain}" ];
          # dnsPropagationCheck = false;
          group = "nginx";
        };
      };
    };

    # public nginx
    containers.public-nginx = {
      autoStart = true;
      config = { config, pkgs, lib, ... }: {
        networking.firewall.allowedTCPPorts = [ 80 443 8443 8008 ];

        services.nginx = {
          enable = true;
          defaultSSLListenPort = 8443;
          defaultHTTPListenPort = 8008;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          clientMaxBodySize = "0";

          virtualHosts = let
            subdomain = "immich-pp";
            port = "3456";
          in
          {
            "default" = {
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
            "${subdomain}.${cfg.localDomain}" = {
              forceSSL = true;
              enableACME = true;
              http2 = true;
              locations = {
                "/" = {
                  proxyPass = "http://127.0.0.1:${port}";
                  proxyWebsockets = true;
                };
              };
            };
          };
        };

        security.acme = {
          acceptTerms = true;
          defaults.email = "dealberapablo07@gmail.com";
          certs = {
            "${cfg.localDomain}" = {
              domain = "immich-pp.${cfg.localDomain}";
              dnsProvider = "cloudflare";
              environmentFile = "/etc/cloudflare.env";
              # webroot = null;
              # dnsPropagationCheck = false;
              group = "nginx";
            };
          };
        };
      };
    };
  };
}
