{ config, pkgs, lib, ... }:

{
  # boot = {
  #   kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
  #   initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
  #   loader = {
  #     grub.enable = false;
  #     generic-extlinux-compatible.enable = true;
  #   };
  # };


  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/NIXOS_SD";
  #     fsType = "ext4";
  #     options = [ "noatime" ];
  #   };
  # };

  networking = {
    hostName = "vm";
    wireless = {
      enable = true;
      networks."Personal-WiFi-724-2.4Ghz".psk = "pejxs8GEVH";
      interfaces = [ "wlan0" ];
    };
  };

  environment.systemPackages = with pkgs; [ firefox ];

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.defaultSession = "xfce";
  };

  users = {
    mutableUsers = false;
    users.lucio = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$hDdVQvRiqT45LYcm3x8mV1$PovTas1Tu5NpvmnR51DzPOSQehePpv7Jb8SSK6z14UC";
    };
  };

  nix.settings.trusted-users = [ "root" "lucio" ];

  # hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
