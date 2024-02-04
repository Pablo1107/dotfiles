{ config, pkgs, lib, ... }:

{
  personal.clone-dotfiles.enable = true;
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
    hostName = "rpi";
    wireless = {
      enable = true;
      networks."Personal-WiFi-724-2.4Ghz".psk = "pejxs8GEVH";
      interfaces = [ "wlan0" ];
    };
  };

  # environment.systemPackages = with pkgs; [ vim ];

  services.openssh = {
    enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  users = {
    mutableUsers = false;
    users.pablo = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$OS4NK14ShiPQoRbXEP2V40$YK3Wj2tcDV7Sk0/vx79sm6VMJ.SAfhuNh85gozlhZy7";
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8rhqit1j9KhWWR2/gJn3sasBlAL4NFb6p2beKs0K39UqR4yMOnWtnR4O8DemdugsW1d1lmUVbBV+Rz6Ma6izccrzImO5q8mY1Rr6kZ2Id2++dl+Gf116r4VxexYrS6pGYy4unDXQCcmV+w5wfuI362Zi1NoLUJU6QY2p7scJhTpl2ONcp+6HA+h+DgMADcZjLWsFn2mKgl4SUoyhrguwXCPMXL8VUaso2tuBP/v7d4PD5GFUD0vqD5KO4Fqy9amFPkUvr1T/u4MrrbSbjO//4BmLbOZaN+CI9LNSL/svSAdCRuwzJrBPiJdAC1HhgX4Y4y/6iTcwPaSRGshguq5DuB2Usvhy01I3erOV/u88VUQU82P6yWTbIZWlzwQ3PCbMfjzRwrsvHFl0F//gejqvdH1CFDDTp6NScTMzK6a+rtosHADkFLFnriTPoi2kQbEHdb7P5WOofQP/7EHsB/5saqLy/pL1ZkgUZQTnoDIwa8Xh0nsJtYDzoXFHXQ5usnuc= pablo@t14s"
        ];
      };
    };
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  nix.settings.trusted-users = [ "root" "pablo" ];

  # hardware.enableRedistributableFirmware = true;
  # system.stateVersion = "23.11";
}
