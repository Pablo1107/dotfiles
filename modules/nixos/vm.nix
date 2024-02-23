{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.vm;
in
{
  options.personal.vm = {
    enable = mkEnableOption "vm";

    bridgeInterface = mkOption {
      type = types.str;
      default = "br0";
    };

    ethInterface = mkOption {
      type = types.str;
      default = "enp4s0";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

    users.users.pablo.extraGroups = [ "libvirtd" ];

    virtualisation.libvirtd = {
      enable = true;
      allowedBridges = [ "${cfg.bridgeInterface}" ];
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
      # spiceUSBRedirection.enable = true;
    };

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-protocol
      virt-viewer
      virtio-win
      win-spice
      gnome.adwaita-icon-theme
      gnome.gnome-boxes
    ];

    home-manager.users.pablo = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };
  };
}
