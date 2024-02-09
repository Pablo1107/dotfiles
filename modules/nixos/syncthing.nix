{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.syncthing;
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
          };
          folders = {
            "Android Camera" = {
              id = "sm-f936b_dkse-photos";
              path = "/home/pablo/Android/Camera";
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
            "org" = {
              id = "org";
              path = "/home/pablo/org";
              devices = [ "SM-F936B" ];
            };
          };
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}
