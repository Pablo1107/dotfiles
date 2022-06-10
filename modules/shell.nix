{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.shell;

  shellAliases = {
    # Default aliases
    sudo = "sudo ";
    ls = "ls --color=auto";
    la = "ls -lah --group-directories-first";
    df = "df -h";
    vim = "nvim";
    td = "date +%Y-%m-%d";
    # open = "setsid -f xdg-open";
    c = "clear";
    mux = "tmuxinator";
    "," = "NIX_AUTO_RUN=1 ";
    pacman = "aura";
    ssh = "TERM=xterm-256color ssh ";
  };

  shellFunctions = ''
    open() {
      if [ -z $2 ]; then
        [ -e $1 ] && setsid -f xdg-open $1 > /dev/null 2>&1
      else
        [ -e $2 ] && setsid -f $1 $2 > /dev/null 2>&1
      fi
    }
  '';

  sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:/usr/share/:/usr/local/share/:$XDG_DATA_DIRS";
    XDG_CURRENT_DESKTOP = "sway";

    XCOMPOSEFILE = "$XDG_CONFIG_HOME/X11/xcompose";
    XCOMPOSECACHE = "$XDG_CACHE_HOME/X11/xcompose";
    GEM_HOME = "$XDG_DATA_HOME/gem";
    GEM_SPEC_CACHE = "$XDG_CACHE_HOME/gem";
    LESSHISTFILE = "-";
    #GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";

    NPM_PACKAGES = "$HOME/.npm-packages";
    PATH = "$HOME/dotfiles/bin:$HOME/scripts:$HOME/.local/bin/:$NPM_PACKAGES/bin:$HOME/.emacs.d/bin:$PATH";
    MANPATH = "\${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man";
    TMUX_SCRIPTS_DIR = "$HOME/dotfiles/config/tmux/scripts";
    MOZ_ENABLE_WAYLAND = 1;
    MOZ_DBUS_REMOTE = 1;

    ROFI_FB_GENERIC_FO = "xdg-open";
    ROFI_FB_PREV_LOC_FILE = "~/.local/share/rofi/rofi_fb_prevloc";
    ROFI_FB_HISTORY_FILE = "~/.local/share/rofi/rofi_fb_history ";
    ROFI_FB_START_DIR = "$HOME";

    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

    PKG_CONFIG_PATH = "$(pkg-config --variable pc_path pkg-config)\${PKG_CONFIG_PATH:+:}\${PKG_CONFIG_PATH}";

    DICPATH = "$DICPATH:$HOME/.nix-profile/share/hunspell:$HOME/nix-profile/share/myspell";

    LEDGER_FILE = "$HOME/ledger/all.journal";

    _JAVA_AWT_WM_NONREPARENTING = 1;
  };
in
{
  options.personal.shell = {
    enable = mkEnableOption "shell";
  };

  config = mkIf cfg.enable {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      history.extended = true;
      history.size = 10000000;
      shellAliases = shellAliases;
      autocd = true;

      initExtra = keyBindings + shellFunctions + ''
        fpath+=${pure-prompt}/share/zsh/site-functions
        autoload -U promptinit;
        promptinit
          prompt pure
 
          eval "$(${pkgs.z-lua}/bin/z --init zsh)"
      '';

      loginExtra = ''
        setopt extendedglob
        setopt appendhistory
        setopt autocd

        source /etc/profile.d/nix-daemon.sh
      '';

      profileExtra = ''
        . /etc/profile
      '';

      # sessionVariables = sessionVariables;
    };

    bash = {
      enable = true;
      # sessionVariables = sessionVariables;
      shellAliases = shellAliases;
    };
  };
}
