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
      default = "enp5s0";
    };
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [ "kvm-intel" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
      kernelParams = [ "intel_iommu=on" "iommu=pt" "pcie_acs_override=downstream,multifunction" "initcall_blacklist=sysfb_init" "vfio_iommu_type1.allow_unsafe_interrupts=1" "kvm.ignore_msrs=1" ];
      # kernelParams = [ "intel_iommu=on" "iommu=pt" "pcie_acs_override=downstream,multifunction" "initcall_blacklist=sysfb_init" "video=simplefb:off" "video=vesafb:off" "video=efifb:off" "video=vesa:off" "disable_vga=1" "vfio_iommu_type1.allow_unsafe_interrupts=1" "kvm.ignore_msrs=1" "modprobe.blacklist=radeon,nouveau,nvidia,nvidiafb,nvidia-gpu,snd_hda_intel,snd_hda_codec_hdmi,i915" ];
      # extraModprobeConfig = "options vfio-pci ids=8086:a780,8086:7ad0,8086:7a86,8086:7aa3,8086:7aa4";
    };

    users.users.pablo.extraGroups = [ "libvirtd" ];

    virtualisation.libvirtd = {
      enable = true;
      allowedBridges = [ "${cfg.bridgeInterface}" ];
      qemu = {
        package = pkgs.qemu-anti-detection;
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
      # spiceUSBRedirection.enable = true;
    };

    environment.etc = {
      "ovmf/edk2-x86_64-secure-code.fd" = {
        source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
      };

      "ovmf/edk2-i386-vars.fd" = {
        source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
      };
    };

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-protocol
      virt-viewer
      virtio-win
      win-spice
      adwaita-icon-theme
      gnome-boxes
    ];

    home-manager.users.pablo = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };

    networking.useDHCP = false;
    networking.interfaces."${cfg.ethInterface}".useDHCP = true;
    networking.interfaces."${cfg.bridgeInterface}".useDHCP = true;
    networking.bridges = {
      "${cfg.bridgeInterface}" = {
        interfaces = [ cfg.ethInterface ];
      };
    };
  };
}
