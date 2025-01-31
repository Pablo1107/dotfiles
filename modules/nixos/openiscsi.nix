{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

with lib;
with myLib;

let
  cfg = config.personal.openiscsi;
in
{
  options.personal.openiscsi = {
    enable = mkEnableOption "openiscsi";
    backingStorePath = mkOption {
      type = types.str;
      default = "/var/lib/targetclid/mydisk.img";
      description = "Path to the file-based backing storage";
    };
    targetIQN = mkOption {
      type = types.str;
      default = "iqn.2025-01.com.example:mytarget";
      description = "iSCSI target IQN";
    };
    initiatorIQN = mkOption {
      type = types.str;
      default = "iqn.2004-10.com.ubuntu:01:dbd9d984ae5b"; # Updated to match Ubuntu's initiator name
      description = "iSCSI initiator IQN";
    };
    storageSize = mkOption {
      type = types.str;
      default = "10G";
      description = "Size of the file-based backing storage";
    };
  };

  config = mkIf cfg.enable {
    services = {
      openiscsi = {
        enable = true;
        name = "iqn.2025-01.com.example:myinitiator";
      };
      target = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [ targetcli ];

    systemd.services.targetclid = {
      description = "iSCSI Target CLI Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.targetcli}/bin/targetclid";
        Restart = "always";
      };
    };

    systemd.services.setup-iscsi-target = {
      description = "Setup iSCSI Target";
      after = [ "targetclid.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        set -e
        if ! ${pkgs.targetcli}/bin/targetcli ls /iscsi/${cfg.targetIQN} &>/dev/null; then
          echo "Creating iSCSI backing store"
          mkdir -p $(dirname ${cfg.backingStorePath})
          if [ ! -f ${cfg.backingStorePath} ]; then
            truncate -s ${cfg.storageSize} ${cfg.backingStorePath}
          fi

          echo "Configuring iSCSI target"
          ${pkgs.targetcli}/bin/targetcli <<EOF
/backstores/fileio create myfile ${cfg.backingStorePath}
/iscsi create ${cfg.targetIQN}
/iscsi/${cfg.targetIQN}/tpg1/luns create /backstores/fileio/myfile
/iscsi/${cfg.targetIQN}/tpg1/acls create ${cfg.initiatorIQN}
/iscsi/${cfg.targetIQN}/tpg1 set attribute authentication=0
/saveconfig
EOF
        else
          echo "iSCSI target already configured. Skipping."
        fi
      '';
    };
  };
}
