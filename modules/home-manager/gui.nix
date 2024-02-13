{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.gui;
in
{
  options.personal.gui = {
    enable = mkEnableOption "gui";
  };


  config = mkIf cfg.enable {
    personal.waybar.enable = true;

    home.file.".local/bin/xterm".source = pkgs.writeScript "xterm" ''
      #!${pkgs.stdenv.shell}
      ${pkgs.alacritty}/bin/alacritty "$@"
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

    # wayland.windowManager.hyprland = {
    #   enable = true;
    #   package = (myLib.nixGLWrapper pkgs {
    #     bin = "Hyprland";
    #     package = pkgs.hyprland;
    #   });
    #   systemdIntegration = false;
    #   extraConfig = null;
    #   plugins = [ ];
    # };

    services = {
      fluidsynth = {
        enable = true;
        soundService = "pipewire-pulse";
      };
    };

    home.packages = with pkgs; [
      (myLib.nixGLWrapper pkgs {
        bin = "Hyprland";
        package = pkgs.hyprland;
      })
      (myLib.nixGLWrapper pkgs {
        bin = "alacritty";
      })
      (myLib.nixGLWrapper pkgs {
        bin = "foot";
      })
      (myLib.nixGLWrapper pkgs {
        bin = "chromium";
      })
      (myLib.nixBothWrapper pkgs {
        bin = "gamescope";
      })
      (myLib.nixGLWrapper pkgs {
        bin = "zoom";
        package = zoom-us;
      })
      (myLib.nixGLWrapper pkgs {
        bin = "anki";
        output = "out";
      })
      element-desktop # matrix client
      slack
      gimp # image editor
      gnome3.gvfs # for sftp mount and stuff like that
      gnome3.nautilus # file manager
      gnome3.nautilus-python
      gnome3.sushi # preview for nautilus
      gnome3.file-roller # archive manager
      unrar # for rar archives
      gnome3.eog # image viewer
      vlc # video player
      qbittorrent # torrent client
      transmission-gtk # torrent client
      libreoffice # office suite
      zathura # pdf viewer
      tdesktop # telegram
      discord
      morgen # calendar

      waybar
      wl-clipboard
      qt5.qtwayland
      xdg-utils
      nixgl.nixGLIntel # wrapper GUI apps
      nixgl.nixVulkanIntel # wrapper GUI apps (Vulkan)
      imv # lightweight image viewer
      xfce.tumbler
      gnome3.gnome-keyring
      wayland-utils
      # poppler-glib
      # ffmpegthumbnailer
      # freetype2
      # libgsf
      # totem
      # mcomix
      hicolor-icon-theme

      # Fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "Hack" ]; })
      font-awesome
      dejavu_fonts
      ibm-plex
      symbola
      material-design-icons
      # apple-fonts
      # nerdfonts

      # Databases
      dbeaver

      insomnia
      # postman

      bitwig-studio # music production
      obsidian
    ];
  };
}
