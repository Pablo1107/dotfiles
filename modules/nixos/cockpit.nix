{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.cockpit;
in
{
  options.personal.cockpit = {
    enable = mkEnableOption "cockpit";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cockpit
      cockpit-machines
      libosinfo # needed for cockpit-machines
      osinfo-db # needed for cockpit-machines
    ];
    environment.pathsToLink = [ "/share/cockpit" ];

    services = {
      cockpit = {
        enable = true;
        port = 9090;
        settings = {
          WebService = {
            AllowUnencrypted = true;
          };
        };
        openFirewall = true;
      };
    };

    # systemd.packages = [ (pkgs.cockpit.override { packages = with pkgs; [ virtmanager ]; }) ];
    # systemd.sockets.cockpit.wantedBy = [ "sockets.target" ];

    # system.activationScripts = {
    #   cockpit = ''
    #     mkdir -p /etc/cockpit/ws-certs.d
    #     chmod 755 /etc/cockpit/ws-certs.d
    #   '';
    # };
    #
    # security.pam.services.cockpit = { };
    #
    #
    # systemd.sockets.cockpit.listenStreams = [ "" "9090" ];
  };
}
