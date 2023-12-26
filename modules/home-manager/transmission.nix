{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.transmission;
in
{
  options.personal.transmission = {
    enable = mkEnableOption "transmission";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      transmission
    ];

    systemd.user.services.transmission = {
      Unit = {
        Description = "Transmission BitTorrent Daemon";
      };

      Service = {
        Type = "notify";

        ExecStart = ''
          ${pkgs.transmission}/bin/transmission-daemon -f
        '';

        ExecReload = ''
          /bin/kill -s HUP $MAINPID
        '';

        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        ProtectSystem = true;
        PrivateTmp = true;
      };

      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}
