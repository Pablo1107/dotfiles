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
    };

    services.immich-public-proxy = {
      enable = true;
      immichUrl = "https://immich.${nginxCfg.localDomain}";
    };
  };
}
