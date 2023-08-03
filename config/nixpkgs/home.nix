{ config, pkgs, myLib, ... }:

with pkgs;

{
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
  personal.shell.envVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # Needed for Trash, SFTP in Nautilus, etc
    # https://github.com/NixOS/nixpkgs/issues/29137#issuecomment-354229533
    GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
  };
  programs.zsh.loginExtra = ''
    source /etc/profile.d/nix-daemon.sh
  '';
  personal.vifm.enable = true;
  personal.sway.enable = true;
  personal.nvim.enable = true;
  personal.npm.enable = true;
  personal.ai.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "pablo";
    homeDirectory = "/home/pablo";
  };

  home.packages = [
    cached-nix-shell
    stow
    htop
    grim
    slurp
    jq
    xdg-user-dirs
    qrcp
    element-desktop
    gimp
    gnome3.gvfs # for sftp mount and stuff like that
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
    qt5.qttools
    unixtools.arp
    ripgrep
    inetutils

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

    (myLib.nixGLWrapper pkgs {
      bin = "chromium";
      package = chromium;
    })
    awscli2

    # Node
    # (yarn.override { nodejs = nodejs-12_x; })
    yarn
    # (yarn.override { nodejs = nodejs-12_x; })
    nodejs
    # nodejs-14_x
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

    morgen
    pop
  ];

  # nix
  caches.cachix = [
    { name = "nix-community"; sha256 = "0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x"; }
  ];

  # home.file.".local/bin/wl-screenshot".source = writeScript "wl-screenshot" (getDotfile "scripts" "wl-screenshot");
  # home.file.".local/bin/git-status".source = writeScript "git-status" (getDotfile "scripts" "git-status");
  home.file.".local/bin/xterm".source = writeScript "xterm" ''
    #!${pkgs.stdenv.shell}
    ${alacritty}/bin/alacritty "$@"
  '';

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
    command-not-found.enable = false;
    nix-index.enable = true;
    go.enable = true;
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
