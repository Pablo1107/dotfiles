{ config, pkgs, ... }:

with pkgs;

let
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

  getDotfile = with builtins; ref: path:
    let
      localPath = ../. + "/${ref}/${path}";
    in
    readFile localPath;

  keyBindings = getDotfile "zsh" "key-bindings.zsh";
in
{
  # programs.mbsync.enable = true;
  # programs.mu.enable = true;
  # accounts.email.accounts.primary = {
  #   primary = true;
  #   address = "dealberapablo07@gmail.com";
  #   userName = "dealberapablo07@gmail.com";
  #   imap.host = "imap.gmail.com";
  #   smtp.host = "smtp.gmail.com";
  #   mbsync = {
  #     enable = true;
  #     create = "maildir";
  #   };
  #   mu.enable = true;
  #   realName = "Pablo Andres Dealbera";
  #   signature = {
  #     text = ''
  #       Pablo Andres Dealbera
  #       Web Developer
  #     '';
  #     showSignature = "append";
  #   };
  #   passwordCommand = "gpg2 -q --for-your-eyes-only --no-tty -d ~/email.gpg";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # personal modules
  personal.dunst.enable = true;
  personal.emacs.enable = true;
  personal.fzf.enable = true;
  personal.git.enable = true;
  personal.gtk.enable = true;
  personal.htop.enable = true;
  personal.nix.enable = true;
  personal.python.enable = true;
  personal.ssh.enable = true;
  personal.syncthing.enable = true;
  personal.xdg.enable = true;
  personal.tmux.enable = true;
  personal.firefox.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "pablo";
    homeDirectory = "/home/pablo";
    sessionVariables = sessionVariables;
  };
  home.packages = [
    stow
    htop
    termite
    alacritty
    dmenu
    pure-prompt
    openssh
    tree
    brillo
    fd
    silver-searcher
    tmuxinator
    xclip
    xsel
    grim
    slurp
    jq
    xdg-user-dirs
    vifm
    qrcp
    element-desktop
    gimp
    gnome3.nautilus
    gnome3.nautilus-python
    gnome3.sushi
    #texlive.combined.scheme-full
    #anki
    slack
    hledger
    tealdeer
    qbittorrent
    vlc
    gnome3.file-roller
    libreoffice
    gnome3.eog
    ffmpeg-full
    geckodriver
    chromedriver
    gnumeric
    go-chromecast
    qt5.qttools
    unixtools.arp
    ripgrep

    # Wayland
    xsettingsd
    waybar
    wl-clipboard
    qt5.qtwayland
    xdg-utils
    nixgl.nixGLIntel
    imv
    xfce.tumbler
    gnome3.gnome-keyring
    wayland-utils
    # poppler-glib
    # ffmpegthumbnailer
    # freetype2
    # libgsf
    # totem
    # mcomix

    chromium
    awscli2

    # Node
    # (yarn.override { nodejs = nodejs-12_x; })
    yarn
    # (yarn.override { nodejs = nodejs-12_x; })
    # nodejs
    nodejs-14_x
    # nodejs-12_x
    deno
    efm-langserver

    # Fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    hack-font
    font-awesome
    dejavu_fonts
    ibm-plex
    symbola
    material-design-icons


    # AWS
    git-remote-codecommit
    git-annex
    git-annex-remote-googledrive

    # Databases
    dbeaver

    insomnia
    postman

    # LSP
    rnix-lsp

    # Rust
    # rustup

    docker-compose
    zathura
    tesseract
    tdesktop
    pandoc
    # mongodb-compass

    man-pages
    # clang

    hicolor-icon-theme
  ];

  # nix
  caches.cachix = [
    { name = "nix-community"; sha256 = "00lpx4znr4dd0cc4w4q8fl97bdp7q19z1d3p50hcfxy26jz5g21g"; }
  ];

  # vifm
  home.file.".config/vifm/vifmrc".text = getDotfile "vifm" "vifmrc";

  # home.file.".config/vifm/colors/solarized-dark.vifm".text = getDotfile "vifm" "colors/solarized-dark.vifm";
  # home.file.".local/bin/wl-screenshot".source = writeScript "wl-screenshot" (getDotfile "scripts" "wl-screenshot");
  # home.file.".local/bin/git-status".source = writeScript "git-status" (getDotfile "scripts" "git-status");
  home.file.".local/bin/xterm".source = writeScript "xterm" ''
    #!${pkgs.stdenv.shell}
    ${alacritty}/bin/alacritty "$@"
  '';
  home.file.".local/share/fonts/cryptocoins.tff".source = fetchurl {
    url = "https://raw.githubusercontent.com/AllienWorks/cryptocoins/master/webfont/cryptocoins.ttf";
    sha256 = "18y3r25x5fb2nk7760dyk9w37kpsaqlh89ak4b1spwggwyq4in5n";
  };

  fonts.fontconfig.enable = true;
  dconf = {
    enable = true;
    # settings = {
    #   "org/gnome/settings-daemon/plugins/xsettings" = {
    #     antialiasing = 1;
    #   };
    # };
  };
  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

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

    command-not-found.enable = true;
    rofi = {
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
  };
  home.file.".config/rofi/desktop.rasi".text = getDotfile "rofi" "desktop.rasi";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
