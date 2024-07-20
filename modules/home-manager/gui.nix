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
      plex-mpv-shim
      element-desktop # matrix client
      slack
      gimp # image editor
      gvfs # for sftp mount and stuff like that
      nautilus # file manager
      nautilus-python
      sushi # preview for nautilus
      file-roller # archive manager
      unrar # for rar archives
      eog # image viewer
      vlc # video player
      qbittorrent # torrent client
      transmission_3-gtk # torrent client
      libreoffice # office suite
      zathura # pdf viewer
      tdesktop # telegram
      discord
      # morgen # calendar
      pavucontrol # pulseaudio volume control

      waybar
      wl-clipboard
      wl-screenshot
      qt5.qtwayland
      xdg-utils
      nixgl.nixGLIntel # wrapper GUI apps
      nixgl.nixVulkanIntel # wrapper GUI apps (Vulkan)
      # imv # lightweight image viewer
      xfce.tumbler
      gnome-keyring
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
      hack-font
      (nerdfonts.override { fonts = [ "Hack" ]; })
      font-awesome
      dejavu_fonts
      ibm-plex
      symbola
      material-design-icons
      # apple-fonts
      # nerdfonts

      # Databases
      dbeaver-bin

      insomnia
      # postman

      obsidian

      spotify

      (wrapOBS.override { inherit obs-studio; } {
        plugins = with obs-studio-plugins; [
          wlrobs
        ];
      })
    ];
  };
}
