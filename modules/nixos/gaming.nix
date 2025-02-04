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
    ];
    programs.steam.enable = true;
    # programs.nix-ld = {
    #   enable = true;
    #   libraries = with pkgs; [
    #     openldap24
    #     libGLU
    #   ] ++ (pkgs.steam-run.fhsenv.args.multiPkgs pkgs);
    # };

    systemd.services.qemu-nbd-connect = {
      description = "Connect QCOW2 file using qemu-nbd";
      before = [ "mnt-qcow2.mount" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.qemu-utils}/bin/qemu-nbd --connect=/dev/nbd0 ${cfg.qcow2Path}";
        ExecStop = "${pkgs.qemu-utils}/bin/qemu-nbd --disconnect /dev/nbd0";
        RemainAfterExit = true;
      };
      wantedBy = [ "multi-user.target" ];
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
        options = "defaults";
        wantedBy = [ "multi-user.target" ];
      }
    ];
  };
}
