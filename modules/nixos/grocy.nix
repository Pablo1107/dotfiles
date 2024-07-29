{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.grocy;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.grocy = {
    enable = mkEnableOption "grocy";
  };

  config = mkIf cfg.enable {
    # services.nginx.virtualHosts =
    #   createVirtualHosts
    #     {
    #       inherit nginxCfg;
    #       subdomain = "grocy";
    #       port = "";
    #     };

    services.nginx.virtualHosts."grocy.${nginxCfg.localDomain}" = {
      useACMEHost = nginxCfg.localDomain;
      forceSSL = false;
      enableACME = false;
      listen = [
        { addr = "192.168.1.34"; port = 2525; }
        { addr = "0.0.0.0"; port = 443; }
        { addr = "[::0]"; port = 443; }
      ];
    };

    services.grocy = {
      enable = true;
      hostName = "grocy.${nginxCfg.localDomain}";
      settings = {
        currency = "ARS";
        culture = "es";
        calendar.firstDayOfWeek = 1; # Monday
      };
      nginx.enableSSL = false;
    };

    # custom.virtualHosts.grocy = {
    #   onlyEnableTLS = true;
    # };

    # FIXME Grocy needs a PHP version with OpenSSL 1.1.1?
    # nixpkgs.config.permittedInsecurePackages = mkIf (versionOlder lib.trivial.release "23.11") [
    #   "openssl-1.1.1w"
    # ];

    environment.systemPackages = with pkgs; [
      # barcodebuddy
    ];
  };
}
