{ config, pkgs, ... }:

with pkgs;

let
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
  personal.rofi.enable = true;
  personal.shell.enable = true;

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

    command-not-found.enable = true;
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
