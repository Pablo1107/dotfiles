{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.rofi;
in
{
  options.personal.rofi = {
    enable = mkEnableOption "rofi";
  };

  config = mkIf cfg.enable {
    personal.shell.envVariables = {
      ROFI_FB_GENERIC_FO = "xdg-open";
      ROFI_FB_PREV_LOC_FILE = "~/.local/share/rofi/rofi_fb_prevloc";
      ROFI_FB_HISTORY_FILE = "~/.local/share/rofi/rofi_fb_history ";
      ROFI_FB_START_DIR = "$HOME";
    };

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
      theme = "desktop";
    };
    home.file.".config/rofi/desktop.rasi".text = myLib.getDotfile "rofi" "desktop.rasi";
  };
}
