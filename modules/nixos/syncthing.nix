{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.syncthing;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    services = {
      syncthing = {
        enable = true;
        openDefaultPorts = true;
        user = "pablo";
        dataDir = "/home/pablo/Documents"; # Default folder for new synced folders
        configDir = "/home/pablo/.config/syncthing"; # Folder for Syncthing's settings and keys
        guiAddress = "0.0.0.0:8384"; # Listen on all interfaces
        # extraOptions.gui = {
        #   user = "pablo";
        #   password = "password"; # I have to research how to manage secrets
        # };
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          devices = {
            "SM-F936B" = { id = "CH4X7XP-YGGL2VQ-FWMWCWN-UXZ76UW-5RLZY3S-QHGDNV3-2R6SNRG-AEFBIQ3"; };
            "steamdeck" = { id = "E6GUAAW-OFYFRAA-V5HDGD3-P5QV7O6-U5NOJ7I-KN7IURW-H5R6XA2-LW6PJQF"; };
            "t14s" = { id = "22OJW2D-ZSZM4H7-AF5CJSO-HTHSOTJ-TBYOIVQ-JROECWX-VQZXH6H-TE7WNA5"; };
          };
          folders = {
            "Android Camera" = {
              id = "sm-f936b_dkse-photos";
              path = "/data/backups/sm-f936b_dkse-photos";
              devices = [ "SM-F936B" ];
            };
            "wiki" = {
              id = "uyct7-9rdjp";
              path = "/home/pablo/wiki";
              devices = [ "SM-F936B" ];
            };
            "ledger" = {
              id = "ledger";
              path = "/home/pablo/ledger";
              devices = [ "SM-F936B" ];
            };
            "super-productivity" = {
              id = "super-productivity";
              path = "/home/pablo/super-productivity";
              devices = [
                "SM-F936B"
                "t14s"
              ];
            };
            # "org" = {
            #   id = "org";
            #   path = "/home/pablo/org";
            #   devices = [ "SM-F936B" ];
            # };
            # "Bitwig Projects" = {
            #   id = "bitwig-projects";
            #   path = "/home/pablo/Bitwig Studio/Projects";
            #   devices = [ "t14s" ];
            # };
          };
        };
      };
      nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "syncthing";
            port = "8384";
          };

      gatus.settings.endpoints = [
        {
          name = "Syncthing";
          url = "https://syncthing." + nginxCfg.localDomain;
          interval = "5m";
          conditions = [ "[STATUS] == 200" "[RESPONSE_TIME] < 300" ];
        }
      ];
    };

    networking.firewall = {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}
