{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.ilv-map;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.ilv-map = {
    enable = mkEnableOption "ilv-map";
  };

  config = mkIf cfg.enable {
    # services.nginx.virtualHosts = {
    #   "lucio-fc-2024.duckdns.org" = {
    #     default = true;
    #     forceSSL = true;
    #     enableACME = true;
    #     http2 = true;
    #     locations."/" = {
    #       proxyPass = "http://127.0.0.1:3000";
    #       proxyWebsockets = true;
    #     };
    #   };
    # };

    services.nginx.virtualHosts =
      createVirtualHosts
        {
          inherit nginxCfg;
          subdomain = "ilv-map";
          port = "4444";
        };

    systemd.services.ilv-map = {
      description = "ilv-map";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.nodePackages.serve}/bin/serve -s build -l 4444";
        Restart = "always";
        RestartSec = 1;
        WorkingDirectory = "/home/pablo/code/ILV-Map";
      };
    };

    # services.mysql = {
    #   enable = true;
    #   # dataDir = "/data/mysql";
    #   package = pkgs.mariadb;
    #   ensureDatabases = [ "ilv-map" ];
    #   ensureUsers = [{
    #     name = "ilv-map";
    #     ensurePermissions = {
    #       "ilv-map.*" = "ALL PRIVILEGES";
    #     };
    #   }];
    # };
  };
}
