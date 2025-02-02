{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

with lib;
with myLib;

let
  cfg = config.personal.nvidia;

  # start script for sway to avoid using GPU
  # https://github.com/hyprwm/Hyprland/issues/8679#issuecomment-2614781004
  start-sway = pkgs.writeScriptBin "start-sway" ''
    #!/usr/bin/env sh
    sudo /var/lib/libvirt/hooks/qemu.d/nvidia-passthrough - prepare
    WLR_DRM_DEVICES=/dev/dri/card0 dbus-run-session sway &
    sleep 2
    sudo /var/lib/libvirt/hooks/qemu.d/nvidia-passthrough - release
  '';
in
{
  options.personal.nvidia = {
    enable = mkEnableOption "nvidia";
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "nvidia" "i915" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = false;
      nvidiaSettings = true;
    };
    hardware.nvidia-container-toolkit.enable = true;

    # boot.initrd.availableKernelModules = [
    #   "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"
    #   "vfio-pci"
    # ];
    # boot.initrd.preDeviceCommands = ''
    #   DEVS="0000:01:00.0 0000:01:00.1"
    #   for DEV in $DEVS; do
    #     echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    #   done
    #   modprobe -i vfio-pci
    # '';

    environment.systemPackages = with pkgs; [
      cudaPackages.cudatoolkit
      openrgb
      start-sway
    ];

    programs.virt-manager = {
      enable = true;
    };

    users.groups.libvirtd.members = [ "pablo" ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        runAsRoot = true;
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
      hooks.qemu = {
        "nvidia-passthrough" = lib.getExe (
          pkgs.writeShellApplication {
            name = "nvidia-passthrough";
            runtimeInputs = [ pkgs.bash ];
            text = ''
              # GUEST_NAME=$1
              OPERATION=$2
              case $OPERATION in
                prepare)
                  # Stop services that might be using the GPU
                  ${pkgs.systemd}/bin/systemctl stop ollama
                  ${pkgs.systemd}/bin/systemctl stop openrgb
                  ${pkgs.systemd}/bin/systemctl stop podman-steam-headless
                  ${pkgs.systemd}/bin/systemctl stop podman-openedai-vision

                  # Avoid race condition
                  sleep 2

                  # Unload nvidia modules
                  ${pkgs.kmod}/bin/modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

                  # Detach GPU from host
                  ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_0
                  ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_1

                  # Load vfio-pci
                  ${pkgs.kmod}/bin/modprobe vfio-pci
                  ;;
                release)
                  # Rebind GPU to host
                  ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_0
                  ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_1

                  # Reload nvidia modules
                  ${pkgs.kmod}/bin/modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia

                  # Restart services that were using the GPU
                  ${pkgs.systemd}/bin/systemctl start ollama
                  ${pkgs.systemd}/bin/systemctl start openrgb
                  ${pkgs.systemd}/bin/systemctl start podman-steam-headless
                  ${pkgs.systemd}/bin/systemctl start podman-openedai-vision
                  ;;
              esac
            '';
          }
        );
      };
    };

    # activation script to run this
    system.activationScripts.libvirtdConfig.text = ''
      ${pkgs.systemd}/bin/systemctl start libvirtd-config.service
    '';

    # turn off RGB
    services.hardware.openrgb.enable = true;
    services.udev.packages = [ pkgs.openrgb ];
    boot.kernelModules = [ "i2c-dev" ];
    hardware.i2c.enable = true;
    systemd.services.no-rgb = let
      no-rgb = pkgs.writeScriptBin "no-rgb" ''
        #!/bin/sh
        NUM_DEVICES=$(${pkgs.openrgb}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)

        for i in $(seq 0 $(($NUM_DEVICES - 1))); do
          ${pkgs.openrgb}/bin/openrgb --noautoconnect --device $i --mode static --color 000000
        done
      '';
    in {
      description = "no-rgb";
      serviceConfig = {
        ExecStart = "${no-rgb}/bin/no-rgb";
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
