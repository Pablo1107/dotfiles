{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.immich;
  nginxCfg = config.personal.reverse-proxy;
  port = "2283";
in
{
  options.personal.immich = {
    enable = mkEnableOption "immich";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts =
      createVirtualHosts
        {
          inherit nginxCfg port;
          subdomain = "immich";
          # https://wiki.nixos.org/wiki/Immich#Using_Immich_behind_Nginx
          extraLocations = {
            "/" = {
              proxyPass = "http://[::1]:${port}";
              proxyWebsockets = true;
              recommendedProxySettings = true;
              extraConfig = ''
                client_max_body_size 50000M;
                proxy_read_timeout   600s;
                proxy_send_timeout   600s;
                send_timeout         600s;
              '';
            };
          };
        };


    systemd.timers."immich-people-to-album" = {
      wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          Unit = "immich-people-to-album.service";
        };
    };

    systemd.services."immich-people-to-album" = {
      script = ''
        ${pkgs.immich-people-to-album}/bin/immich-people-to-album --server_url=$SERVER_URL --email=$EMAIL --password=$PASSWORD --people_id=92cbc2db-39ec-4019-8879-d6afe752d36e --album_id=6b532fb2-0ec2-4755-9afc-7acb03ba0326
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        EnvironmentFile = "/etc/immich/immich-people-to-album.env";
      };
    };

    services.immich = {
      enable = true;
      mediaLocation = "/data/services/immich";
      host = "::";
    };

    services.immich-public-proxy = {
      enable = true;
      immichUrl = "https://immich.${nginxCfg.localDomain}";
      port = 3456;
    };

    services.gatus.settings.endpoints = [
      {
        name = "Immich";
        url = "https://immich." + nginxCfg.localDomain;
        interval = "5m";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 300"
        ];
      }
      {
        name = "Immich Public Proxy";
        url = "https://immich-pp." + nginxCfg.localDomain;
        interval = "5m";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 300"
        ];
      }
      {
        name = "Immich Public Proxy [Internal Service]";
        url = "http://localhost:3456";
        interval = "5m";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 300"
        ];
      }
    ];
  };
}
