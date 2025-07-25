{ config, options, lib, myLib, pkgs, pkgs-patched, ... }:

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

    LEDGER_FILE = mkDefault "$HOME/ledger/all.journal";

    _ZO_MAXAGE = "10000000";
  };

  keyBindings = myLib.getDotfile "zsh" "key-bindings.zsh";
in
{
  options.personal.shell = {
    enable = mkEnableOption "shell";

    envVariables = mkOption {
      type = with types; lazyAttrsOf (oneOf [ str path int float ]);
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
      tree
      fd
      silver-searcher
      tmuxinator
      ripgrep
      elixir
      inetutils
      docker-compose
      pop # email client
      shell-gpt
      devenv
    ];
    home.sessionVariables = mkMerge [ sessionVariables cfg.envVariables ];
    home.sessionPath = cfg.path;

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      history.extended = true;
      history.size = 10000000;
      shellAliases = shellAliases;
      autocd = true;

      initExtra = keyBindings + shellFunctions + ''
        fpath+=${pkgs.pure-prompt}/share/zsh/site-functions
        autoload -U promptinit;
        promptinit
        prompt pure

        # Shell-GPT integration ZSH v0.2
        _sgpt_zsh() {
        if [[ -n "$BUFFER" ]]; then
            _sgpt_prev_cmd=$BUFFER
            BUFFER+="⌛"
            zle -I && zle redisplay
            BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
            zle end-of-line
        fi
        }
        zle -N _sgpt_zsh
        bindkey ^l _sgpt_zsh
        # Shell-GPT integration ZSH v0.2
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

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.nix-index.enable = true;
    programs.nix-index-database = {
      comma.enable = true;
    };

    programs.zoxide = {
      enable = true;
    };

    xresources.properties = {
      "xterm.background" = "#1E1E2E";
      "xterm.foreground" = "white";
      "xterm.faceName" = "Hack";
      "xterm.faceSize" = "12";
      "xterm.geometry" = "95x23";
    };
  };
}

