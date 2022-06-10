{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.rofi;
in
{
  options.personal.rofi = {
    enable = mkEnableOption "rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      extraConfig = {
        modi = "run,ssh,drun";
        kb-row-up = "Up,Alt+k,Shift+Tab,Shift+ISO_Left_Tab";
        kb-row-down = "Down,Alt+j";
        kb-accept-entry = "Control+m,Return,KP_Enter";
        terminal = "alacritty";
        kb-remove-to-eol = "Control+Shift+e";
        kb-mode-next = "Shift+Right,Control+Tab,Alt+l";
        kb-mode-previous = "Shift+Left,Control+Shift+Tab,Alt+h";
        kb-remove-char-back = "BackSpace";
      };
    };
    home.file.".config/rofi/desktop.rasi".text = getDotfile "rofi" "desktop.rasi";
  };
}
