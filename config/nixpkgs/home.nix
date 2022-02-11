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
    open = "setsid -f xdg-open";
    c = "clear";
    mux = "tmuxinator";
    "," = "NIX_AUTO_RUN=1 ";
    pacman = "aura";
    ssh = "TERM=xterm-256color ssh ";
  };

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
    PATH = "$HOME/dotfiles/bin:$HOME/scripts:$HOME/.local/bin/:$NPM_PACKAGES/bin:$PATH";
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
  };

  getDotfile = with builtins; ref: path:
    let
      localPath = ../. + "/${ref}/${path}";
    in
    readFile localPath;

  keyBindings = getDotfile "zsh" "key-bindings.zsh";
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    ag
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
    #texlive.combined.scheme-full
    #anki
    slack
    hledger
    tealdeer

    # Wayland
    xsettingsd
    waybar
    wl-clipboard
    qt5.qtwayland
    xdg-utils

    # Python
    python.pkgs.pip
    (python38.withPackages (ps: with ps; [ tkinter setuptools pip wheel pynvim ]))

    chromium
    awscli2

    # Node
    (yarn.override { nodejs = nodejs-12_x; })
    nodejs
    deno
    nur.repos.crazazy.efm-langserver

    # Fonts
    hack-font
    font-awesome
    dejavu_fonts
    material-design-icons

    # AWS
    git-remote-codecommit

    # Databases
    dbeaver

    insomnia
    postman

    # LSP
    rnix-lsp
  ];

  # vifm
  home.file.".config/vifm/vifmrc".text = getDotfile "vifm" "vifmrc";

  fonts.fontconfig.enable = true;
  xdg = {
    userDirs = {
      enable = true;
      desktop = "\$HOME/desktop";
      documents = "\$HOME/docs";
      download = "\$HOME/downloads";
      music = "\$HOME/music";
      pictures = "\$HOME/pictures";
      videos = "\$HOME/videos";
      publicShare = "\$HOME/desktop/public";
      templates = "\$HOME/desktop/templates";
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
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
        package = arc-theme;
        name = "Arc-Dark";
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
  dconf = {
    enable = true;
    # settings = {
    #   "org/gnome/settings-daemon/plugins/xsettings" = {
    #     antialiasing = 1;
    #   };
    # };
  };
  programs = {
    firefox = {
      enable = true;
      package = firefox-wayland;
      profiles =
        let
          defaultSettings = {
            "browser.aboutConfig.showWarning" = false;
            "browser.startup.page" = 3;
            "browser.tabs.insertAfterCurrent" = true;
            "browser.tabs.tabMinWidth" = 200;
            "browser.uidensity" = 1;
            "devtools.theme" = "dark";
            "gfx.webrender.all" = true;
            "gfx.webrender.enabled" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "ui.systemUsesDarkTheme" = 1;
          };
        in
        {
          pablo = {
            id = 0;
            settings = defaultSettings;
            userChrome = getDotfile "firefox" "chrome/userChrome.css";
            userContent = getDotfile "firefox" "chrome/userContent.css";
          };
        };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        privacy-badger
        multi-account-containers
        https-everywhere
        darkreader
      ];
    };

    git = {
      enable = true;
      userName = "Pablo Andres Dealbera";
      userEmail = "dealberapablo07@gmail.com";
      extraConfig = {
        credential = {
          helper = "store";
        };
      };
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      history.extended = true;
      history.size = 10000000;
      shellAliases = shellAliases;

      initExtra = keyBindings + ''
        fpath+=${pure-prompt}/share/zsh/site-functions
        autoload -U promptinit; promptinit
        prompt pure

        eval "$(${pkgs.z-lua}/bin/z --init zsh)"
      '';

      loginExtra = ''
        setopt extendedglob
        setopt appendhistory
        setopt autocd

        source /etc/profile.d/nix{,-daemon}.sh
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

    ssh.enable = true;
    fzf = {
      enable = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
      fileWidgetCommand = "$FZF_DEFAULT_COMMAND";
      defaultOptions = [
        "--bind tab:toggle-out,shift-tab:toggle-in"
        "--bind alt-j:down,alt-k:up,ctrl-j:preview-down,ctrl-k:preview-up"
        "--color=dark"
        "--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f"
        "--color=info:#7aa6da,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
      ];
    };
    command-not-found.enable = true;
    tmux = {
      enable = true;
      extraConfig = getDotfile "tmux" ".tmux.conf";
    };
    htop = {
      enable = true;
      settings = {
        hideThreads = true;
        hideUserlandThreads = true;
        showCpuUsage = true;
        showProgramPath = false;
        vimMode = true;
        fields = with config.lib.htop.fields; [
          PID
          USER
          PRIORITY
          NICE
          M_SIZE
          M_RESIDENT
          M_SHARE
          STATE
          PERCENT_CPU
          PERCENT_MEM
          TIME
          COMM
        ];
        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;
      } // (with config.lib.htop; leftMeters [
        (bar "LeftCPUs2")
        (bar "Memory")
        (bar "Swap")
      ]) // (with config.lib.htop; rightMeters [
        (bar "RightCPUs2")
        (text "Tasks")
        (text "LoadAverage")
        (text "Uptime")
        (text "Systemd")
      ]);
    };

    rofi = {
      enable = true;
      package = nur.repos.kira-bruneau.rofi-wayland;
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

  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "nautilus.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "x-scheme-handler/postman" = [ "Postman.desktop" ];
      "x-scheme-handler/slack" = [ "slack.desktop" ];
      "x-scheme-handler/eclipse+command" = [ "dbeaver.desktop" ];
    };
  };

  wayland.windowManager.sway = {
    enable = false;
    # extraPackages = with pkgs; [ some_packages ];
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export LD_LIBRARY_PATH=/lib/dri
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

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
