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
