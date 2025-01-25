{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

with lib;
with myLib;

let
  cfg = config.personal.nvidia;
in
{
  options.personal.nvidia = {
    enable = mkEnableOption "nvidia";
  };

  config = mkIf cfg.enable {
    # boot.initrd.kernelModules = [ "nvidia" "i915" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    # hardware.graphics.enable = true;
    # services.xserver.videoDrivers = [ "nvidia" ];
    # hardware.nvidia = {
    #   package = config.boot.kernelPackages.nvidiaPackages.stable;
    #   open = false;
    #   nvidiaSettings = true;
    # };

    boot.initrd.availableKernelModules = [ "amdgpu" "vfio-pci" ];
    boot.initrd.preDeviceCommands = ''
      DEVS="0000:01:00.0 0000:01:00.1"
      for DEV in $DEVS; do
        echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
      done
      modprobe -i vfio-pci
    '';

    environment.systemPackages = with pkgs; [
      cudaPackages.cudatoolkit
    ];

    programs.virt-manager = {
      enable = true;
    };

    users.groups.libvirtd.members = [ "pablo" ];

    virtualisation.libvirtd = {
      enable = true;
      qemuOvmf = true;
      qemuRunAsRoot = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };
}
