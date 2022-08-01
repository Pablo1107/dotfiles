{ config, options, lib, myLib, pkgs, ... }:

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
    # "," = "NIX_AUTO_RUN=1 ";
    pacman = "aura";
    ssh = "TERM=xterm-256color ssh ";
    icat = "kitty +kitten icat";
    imgcat = "wezterm imgcat";
  };

  shellFunctions =
    if pkgs.stdenv.isLinux then ''
      open() {
        if [ -z $2 ]; then
          [ -e $1 ] && setsid -f xdg-open $1 > /dev/null 2>&1
        else
          [ -e $2 ] && setsid -f $1 $2 > /dev/null 2>&1
        fi
      }
    '' else "";

  sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    XCOMPOSEFILE = "$XDG_CONFIG_HOME/X11/xcompose";
    XCOMPOSECACHE = "$XDG_CACHE_HOME/X11/xcompose";
    GEM_HOME = "$XDG_DATA_HOME/gem";
    GEM_SPEC_CACHE = "$XDG_CACHE_HOME/gem";
    LESSHISTFILE = "-";
    #GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";

    TMUX_SCRIPTS_DIR = "$HOME/dotfiles/config/tmux/scripts";

    PKG_CONFIG_PATH = "$(${pkgs.pkg-config}/bin/pkg-config --variable pc_path pkg-config)\${PKG_CONFIG_PATH:+:}\${PKG_CONFIG_PATH}";

    DICPATH = "$DICPATH:$HOME/.nix-profile/share/hunspell:$HOME/nix-profile/share/myspell";

    LEDGER_FILE = "$HOME/ledger/all.journal";
  };

  keyBindings = myLib.getDotfile "zsh" "key-bindings.zsh";
in
{
  options.personal.shell = {
    enable = mkEnableOption "shell";

    envVariables = mkOption {
      type = types.attrsOf types.str;
      example = { EDITOR = "nvim"; };
      default = { };
    };

    path = mkOption {
      type = types.listOf types.str;
      example = [
        "$HOME/.local/bin"
        "\${xdg.configHome}/emacs/bin"
        ".git/safe/../../bin"
      ];
      default = [
        "$HOME/dotfiles/bin:"
        "$HOME/scripts"
        "$HOME/.local/bin/"
        "$HOME/.emacs.d/bin"
      ];
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      alacritty
      tree
      fd
      silver-searcher
      tmuxinator
      ripgrep
      comma
      elixir
    ];
    home.sessionVariables = mkMerge [ sessionVariables cfg.envVariables ];
    home.sessionPath = cfg.path;

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      history.extended = true;
      history.size = 10000000;
      shellAliases = shellAliases;
      autocd = true;

      initExtra = keyBindings + shellFunctions + ''
        fpath+=${pkgs.pure-prompt}/share/zsh/site-functions
        autoload -U promptinit;
        promptinit
        prompt pure
        eval "$(${pkgs.z-lua}/bin/z --init zsh)"
      '';

      loginExtra = ''
        setopt extendedglob
        setopt appendhistory
        setopt autocd
      '';

      profileExtra = ''
        . /etc/profile
      '';

      # sessionVariables = sessionVariables;
    };

    programs.bash = {
      enable = true;
      # sessionVariables = sessionVariables;
      shellAliases = shellAliases;
    };
  };
}

