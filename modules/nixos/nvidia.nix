{ config, options, lib, myLib, pkgs, pkgs-stable, pkgs-patched, ... }:

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

  vulkanDriverFiles = [
    "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.x86_64.json"
    "${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd.i686.json"
  ];

  nvidia-vulkan = pkgs.writeShellScriptBin "nvidia-vulkan" ''
    export VK_DRIVER_FILES="${lib.concatStringsSep ":" vulkanDriverFiles}"
    exec "$@"
  '';

  gamescope-session = pkgs.writeShellScriptBin "gamescope-session" ''
    ${nvidia-vulkan}/bin/nvidia-vulkan gamescope -h 1440 -H 1440 -r 170 --adaptive-sync --steam  -- steam -tenfoot -pipewire-dmabuf
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
      package = config.boot.kernelPackages.nvidiaPackages.beta;
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
      nvidia-vulkan
      gamescope-session
      gwe
      corectrl
      (gpu-burn.override {
        config = {
          cudaSupport = true;
        };
      })
      nvtopPackages.nvidia
      pkgs-patched.nvidia_oc
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
                  ${pkgs.systemd}/bin/systemctl stop shared.mount
                  ${pkgs.systemd}/bin/systemctl stop qemu-nbd-connect.service

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
                  ${pkgs.systemd}/bin/systemctl start shared.mount
                  ${pkgs.systemd}/bin/systemctl start qemu-nbd-connect.service
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
