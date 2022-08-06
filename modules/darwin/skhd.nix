{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.skhd;
in
{
  options.personal.skhd = with types; {
    enable = mkEnableOption "skhd";
  };

  config = mkIf cfg.enable {
    services.skhd = {
      enable = true;
      skhdConfig = ''
        cmd - return : open -na Alacritty.app
        cmd - h : yabai -m window --focus west
        cmd - l : yabai -m window --focus east
        cmd - j : yabai -m window --focus south
        cmd - k : yabai -m window --focus north

        # swap managed window
        shift + cmd - h : yabai -m window --warp west
        shift + cmd - l : yabai -m window --warp east
        shift + cmd - j : yabai -m window --warp south
        shift + cmd - k : yabai -m window --warp north

        # balance size of windows
        shift + cmd - 0 : yabai -m space --balance

        # fast focus desktop
        # cmd - tab : yabai -m space --focus recent
        cmd - 1 : yabai -m space --focus 1
        cmd - 2 : yabai -m space --focus 2
        cmd - 3 : yabai -m space --focus 3
        cmd - 4 : yabai -m space --focus 4
        cmd - 5 : yabai -m space --focus 5
        cmd - 6 : yabai -m space --focus 6
        cmd - 7 : yabai -m space --focus 7
        cmd - 8 : yabai -m space --focus 8

        # shift + cmd - 1 : yabai -m window --space 1
        # shift + cmd - 2 : yabai -m window --space 2
        # shift + cmd - 3 : yabai -m window --space 3
        # shift + cmd - 4 : yabai -m window --space 4
        # shift + cmd - 5 : yabai -m window --space 5
        # shift + cmd - 6 : yabai -m window --space 6
        # shift + cmd - 7 : yabai -m window --space 7
        # shift + cmd - 8 : yabai -m window --space 8

        # control window size, modified to be intuitive
        cmd + ctrl - h : yabai -m window --resize left:-20:0  || yabai -m window --resize right:-20:0
        cmd + ctrl - l : yabai -m window --resize right:20:0  || yabai -m window --resize left:20:0
        cmd + ctrl - j : yabai -m window --resize bottom:0:20 || yabai -m window --resize top:0:20
        cmd + ctrl - k : yabai -m window --resize top:0:-20   || yabai -m window --resize bottom:0:-20
        cmd + ctrl - f : yabai -m window --toggle zoom-fullscreen

        # float / unfloat window and center on screen
        cmd - space : yabai -m window --toggle float;\
                  yabai -m window --grid 4:4:1:1:2:2

        # close window yabai way, not overriding system default
        cmd + shift - q : yabai -m window --close

        # toggle layout (bsp/float)
        cmd + shift - space : [ "$(yabai -m config layout)" = "bsp" ] && yabai -m config layout float || yabai -m config layout bsp
      '';
    };
  };
}
