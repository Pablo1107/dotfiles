{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.yabai;

  barCfg = config.personal.sketchybar;
  isBarEnabled = barCfg.enable;
  barHeight = barCfg.height;
in
{
  options.personal.yabai = with types; {
    enable = mkEnableOption "yabai";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.yabai ];

    services.yabai = {
      enable = true;
      package = pkgs.yabai;
      config = {
        # layout
        layout = "bsp";
        #auto_balance = "on";
        split_ratio = "0.62";
        # Gaps
        top_padding = if isBarEnabled then barHeight + 2 else 2;
        bottom_padding = "2";
        left_padding = "2";
        right_padding = "2";
        window_gap = "12";
        # shadows and borders
        #window_shadow = "on";
        window_border = "on";
        window_border_width = 1;
        active_window_border_color = "0xff007CA6";
        normal_window_border_color = "0x00ffffff";
        window_opacity = "on";
        window_opacity_duration = "0.1";
        active_window_opacity = "1.0";
        normal_window_opacity = "0.9";
        # mouse
        mouse_modifier = "cmd";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";
        mouse_follows_focus = "on";
        focus_follows_mouse = "autoraise";
      };
      extraConfig = ''
        # load script for extended features
        sudo yabai --load-sa
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

        # Do not manage windows with certain titles eg. Copying files or moving to bin
        yabai -m rule --add title="(Copy|Bin|About This Mac|Info)" manage=off

        # Do not manage some apps which are not resizable
        yabai -m rule --add app="^(Calculator|System Preferences|[sS]tats)$" layer=above manage=off
      '';
    };
  };
}
