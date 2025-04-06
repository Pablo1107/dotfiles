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
    services.syncthing = {
      enable = true;
      # tray.enable = true;
    };
    # Fix tray.target not found
    # systemd.user.targets = {
    #   tray = {
    #     Unit = {
    #       Description = "Tray";
    #     };
    #   };
    # };
  };
}
