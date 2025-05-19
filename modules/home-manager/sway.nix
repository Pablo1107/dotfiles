{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.sway;
in
{
  options.personal.sway = {
    enable = mkEnableOption "sway";
  };

  config = mkIf cfg.enable {
    # sway installed on arch linux
    home.packages = with pkgs; [
      brillo
      grim
      slurp
      jq
      wl-clipboard
      xdg-utils
    ];

    personal.shell.envVariables = {
      XDG_CURRENT_DESKTOP = "sway";
    };

    home.persistence."${config.home.homeDirectory}/dotfiles/config" = {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "sway/.config/sway/config"
        "sway/.config/sway/import-gsettings"
        "sway/.config/sway/shotman.conf"
        "sway/.config/sway/maximize.sh"
        "sway/.config/sway/clamshell.sh"
        "sway/.config/sway/bg.jpeg"
      ];
    };

    xdg.portal = {
      xdgOpenUsePortal = true;
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config = {
        sway = {
          default = [
            "wlr"
            "gtk"
          ];
        };
      };
    };
  };
}
