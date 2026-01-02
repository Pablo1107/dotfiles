{ config, options, lib, pkgs, pkgs-unstable, ... }:

with lib;

let
  cfg = config.personal.niri;
in
{
  options.personal.niri = {
    enable = mkEnableOption "niri";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brillo
      grim
      slurp
      jq
      wl-clipboard
      xdg-utils
      swaybg
      pkgs-unstable.xwayland-satellite # 0.8 https://github.com/Supreeeme/xwayland-satellite/commit/04816e2a3634087db3de39043fcc9db2afcb0c44
      pwvucontrol
    ];

    # this needs to be activated at NixOS level
    # services.gnome.gnome-keyring.enable = true;

    services.mako.enable = true;

    home.persistence."${config.home.homeDirectory}/dotfiles/config" = {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "niri/.config/niri/config.kdl"
        "niri/.config/niri/bg.jpeg"
      ];
    };

    xdg.portal = {
      xdgOpenUsePortal = true;
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config = {
        niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Access" = "gtk";
          "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        };
      };
    };
  };
}
