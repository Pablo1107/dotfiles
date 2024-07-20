{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.transmission;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.transmission = {
    enable = mkEnableOption "transmission";
  };

  config = mkIf cfg.enable {
    services = {
      transmission = {
        enable = true; #Enable transmission daemon
        group = "arr";
        openRPCPort = true; #Open firewall for RPC
        settings = {
          rpc-authentication-required = false;
          rpc-bind-address = "0.0.0.0";
          rpc-host-whitelist-enabled = false;
          rpc-whitelist-enabled = false;
          rpc-port = 9091;
          ratio-limit = 3;
          ratio-limit-enabled = true;
        };
      };
    };

    users.groups.arr = {};
    users.users.pablo.extraGroups = [ "transmission" "arr" ];

    services = {
      jellyfin = {
        enable = true;
        openFirewall = true;
        group = "arr";
      };
      # jackett = {
      #   enable = true;
      #   openFirewall = true;
      # };
      radarr = {
        enable = true;
        openFirewall = true;
        group = "arr";
      };
      bazarr = {
        enable = true;
        openFirewall = true;
        group = "arr";
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
      };

      nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "transmission";
            port = "9091";
          } //
        # createVirtualHosts
        #   {
        #     inherit nginxCfg;
        #     subdomain = "jackett";
        #     port = "9117";
        #   } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "radarr";
            port = "7878";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "bazarr";
            port = "6767";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "prowlarr";
            port = "9696";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "jellyfin";
            port = "8096";
          };
    };
    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        # dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };

      # https://github.com/NixOS/nixpkgs/issues/294789#issuecomment-2016820757
      oci-containers = {
        backend = "podman";
        containers = {
          flare-solvarr = {
            image = "ghcr.io/flaresolverr/flaresolverr:latest";
            autoStart = true;
            ports = ["127.0.0.1:8191:8191"];
            environment = {
              LOG_LEVEL = "info";
              LOG_HTML = "false";
              CAPTCHA_SOLVER = "hcaptcha-solver";
              TZ="America/New_York";
            };
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      jellyfin-media-player
      jellyfin-mpv-shim
    ];
  };
}
