{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.dunst;
in
{
  options.personal.dunst = {
    enable = mkEnableOption "dunst";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = "Fira Mono Bold 10px";
          monitor = 0;
          follow = "none";
          geometry = "500x5-10+10";
          shrink = true;

          # borders
          padding = 25;
          horizontal_padding = 25;
          frame_width = 0;
          frame_color = "#daddee";
          separator_height = 0;
          separator_color = "frame";

          markup = "full";
          format = "%s\n%b";
          alignment = "center";
          word_wrap = true;

          # dmenu               = /usr/bin/rofi -dmenu -p dunst:
          browser = "firefox -new-tab";

          idle_threshold = 120;
          show_age_threshold = 60;

          icon_position = "left";
          max_icon_size = 32;

          mouse_middle_lick = "do_action,close_current";
        };

        experimental = {
          per_monitor_dpi = true;
        };

        shortcuts = {
          #close = "ctrl+space";
          #close_all = "ctrl+shift+space";
          history = "ctrl+shift+grave";
          context = "ctrl+shift+period";
        };

        urgency_low = {
          background = "#25252d";
          foreground = "#fafafa";
          timeout = 5;
        };

        urgency_normal = {
          background = "#25252d";
          foreground = "#fafafa";
          timeout = 15;
        };

        urgency_critical = {
          background = "#007CA6";
          foreground = "#fafafa";
          timeout = 0;
        };
      };
    };
  };
}
