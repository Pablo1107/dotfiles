{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.gaming;
  # nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.gaming = {
    enable = mkEnableOption "gaming";

    qcow2Path = mkOption {
      type = types.str;
      default = "/var/lib/libvirt/images/games.qcow2";
      description = "Path to your QCOW2 image";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "nbd" ];

    environment.systemPackages = with pkgs; [
      (lutris.override {
        extraLibraries = pkgs: [
          libgudev
          speex
          libvdpau
          libusb1
          gst_all_1.gst-plugins-bad
        ];
        extraPkgs = pkgs: [
          wineWowPackages.waylandFull
          pango
        ];
      })
      wineWowPackages.waylandFull
      heroic
      yuzu
    ];
    programs.steam = {
      enable = true;
      package = (pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          libGLU
          libsForQt5.qt5.qtbase
        ];
        extraLibraries = pkgs: with pkgs; [
          libGLU
          libsForQt5.qt5.qtbase
        ];
      });
      gamescopeSession = {
        enable = true;
      };
    };
    programs.alvr.enable = true;

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
# List by default
        zlib
          zstd
          stdenv.cc.cc
          curl
          openssl
          attr
          libssh
          bzip2
          libxml2
          acl
          libsodium
          util-linux
          xz
          systemd

# My own additions
          xorg.libXcomposite
          xorg.libXtst
          xorg.libXrandr
          xorg.libXext
          xorg.libX11
          xorg.libXfixes
          libGL
          libva
          pipewire
          xorg.libxcb
          xorg.libXdamage
          xorg.libxshmfence
          xorg.libXxf86vm
          libelf

# Required
          glib
          gtk2

# Inspired by steam
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/st/steam/package.nix#L36-L85
          networkmanager
          vulkan-loader
          libgbm
          libdrm
          libxcrypt
          coreutils
          pciutils
          zenity
# glibc_multi.bin # Seems to cause issue in ARM

# # Without these it silently fails
          xorg.libXinerama
          xorg.libXcursor
          xorg.libXrender
          xorg.libXScrnSaver
          xorg.libXi
          xorg.libSM
          xorg.libICE
          # gnome2.GConf
          nspr
          nss
          cups
          libcap
          SDL2
          libusb1
          dbus-glib
          ffmpeg
# Only libraries are needed from those two
          libudev0-shim

# needed to run unity
          gtk3
          icu
          libnotify
          gsettings-desktop-schemas
# https://github.com/NixOS/nixpkgs/issues/72282
# https://github.com/NixOS/nixpkgs/blob/2e87260fafdd3d18aa1719246fd704b35e55b0f2/pkgs/applications/misc/joplin-desktop/default.nix#L16
# log in /home/leo/.config/unity3d/Editor.log
# it will segfault when opening files if you don’t do:
# export XDG_DATA_DIRS=/nix/store/0nfsywbk0qml4faa7sk3sdfmbd85b7ra-gsettings-desktop-schemas-43.0/share/gsettings-schemas/gsettings-desktop-schemas-43.0:/nix/store/rkscn1raa3x850zq7jp9q3j5ghcf6zi2-gtk+3-3.24.35/share/gsettings-schemas/gtk+3-3.24.35/:$XDG_DATA_DIRS
# other issue: (Unity:377230): GLib-GIO-CRITICAL **: 21:09:04.706: g_dbus_proxy_call_sync_internal: assertion 'G_IS_DBUS_PROXY (proxy)' failed

# Verified games requirements
          xorg.libXt
          xorg.libXmu
          libogg
          libvorbis
          SDL
          SDL2_image
          glew110
          libidn
          tbb

# Other things from runtime
          flac
          freeglut
          libjpeg
          libpng
          libpng12
          libsamplerate
          libmikmod
          libtheora
          libtiff
          pixman
          speex
          SDL_image
          SDL_ttf
          SDL_mixer
          SDL2_ttf
          SDL2_mixer
          libappindicator-gtk2
          libdbusmenu-gtk2
          libindicator-gtk2
          libcaca
          libcanberra
          libgcrypt
          libvpx
          librsvg
          xorg.libXft
          libvdpau
# ...
# Some more libraries that I needed to run programs
          pango
          cairo
          atk
          gdk-pixbuf
          fontconfig
          freetype
          dbus
          alsa-lib
          expat
# for blender
          libxkbcommon

          libxcrypt-legacy # For natron
          libGLU # For natron

# Appimages need fuse, e.g. https://musescore.org/fr/download/musescore-x86_64.AppImage
          fuse
          e2fsprogs
          ];
    };

    # programs.nix-ld = {
    #   enable = true;
    #   libraries = with pkgs; [
    #     openldap24
    #     libGLU
    #   ] ++ (pkgs.steam-run.fhsenv.args.multiPkgs pkgs);
    # };

    # needed for gamescope
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    systemd.services.qemu-nbd-connect = {
      description = "Connect QCOW2 file using qemu-nbd";
      unitConfig = {
        # Make sure this service is started before the mount
        # Before = [ "shared.mount" ];
        # After = [ "local-fs.target" ];
        DefaultDependencies = false;
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.qemu-utils}/bin/qemu-nbd --connect=/dev/nbd0 ${cfg.qcow2Path}";
        ExecStop = "${pkgs.qemu-utils}/bin/qemu-nbd --disconnect /dev/nbd0";
        RemainAfterExit = true;
        DefaultDependencies = false;
      };

      bindsTo = [ "shared.mount" ];
      partOf = [ "shared.mount" ];
    };

    boot.supportedFilesystems = [ "ntfs" ];

    systemd.mounts = [
      {
        description = "Mount QCOW2 NTFS partition";
        requires = [ "qemu-nbd-connect.service" ];
        after = [ "qemu-nbd-connect.service" ];
        what = "/dev/nbd0p2";
        where = "/shared";
        type = "ntfs";
        options = "defaults,uid=1000,gid=100";
        wantedBy = [ "multi-user.target" ];
      }
    ];

    hardware.xpadneo.enable = true;

    hardware.bluetooth.settings = {
      General = {
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = true;
      };
    };

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
      extraModprobeConfig = ''
        options bluetooth disable_ertm=Y
      '';
    };
  };
}
