{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.gtk;
in
{
  options.personal.gtk = {
    enable = mkEnableOption "gtk";
  };

  config = mkIf cfg.enable {
    personal.shell.envVariables = {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      GTK_THEME = "Arc-Dark";
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };
    gtk =
      let
        extraConfig = {
          gtk-cursor-theme-name = "Adwaita";
          gtk-cursor-theme-size = 0;
          gtk-toolbar-style = "GTK_TOOLBAR_BOTH_HORIZ";
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
          gtk-button-images = 0;
          gtk-menu-images = 0;
          gtk-enable-event-sounds = 1;
          gtk-enable-input-feedback-sounds = 1;
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintmedium";
        };
      in
      {
        enable = true;
        theme = {
          # package = pkgs.arc-theme;
          name = "Adwaita";
        };
        iconTheme = {
          name = "Adwaita";
        };
        font = {
          name = "Sans 10";
        };
        gtk2.extraConfig = ''
          gtk-cursor-theme-name="${extraConfig.gtk-cursor-theme-name}"
          gtk-cursor-theme-size=${toString extraConfig.gtk-cursor-theme-size}
          gtk-toolbar-style=${extraConfig.gtk-toolbar-style};
          gtk-toolbar-icon-size=${extraConfig.gtk-toolbar-icon-size};
          gtk-button-images=${toString extraConfig.gtk-button-images}
          gtk-menu-images=${toString extraConfig.gtk-menu-images}
          gtk-enable-event-sounds=${toString extraConfig.gtk-enable-event-sounds}
          gtk-enable-input-feedback-sounds=${toString extraConfig.gtk-enable-input-feedback-sounds}
          gtk-xft-antialias=${toString extraConfig.gtk-xft-antialias}
          gtk-xft-hinting=${toString extraConfig.gtk-xft-hinting}
          gtk-xft-hintstyle="${extraConfig.gtk-xft-hintstyle}"
        '';
        gtk3.extraConfig = extraConfig;
      };
  };
}
