{ modulesPath, config, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  personal.syncthing.enable = true;
  personal.immich.enable = true;
  personal.homepage-dashboard.enable = true;
  personal.duckdns.enable = true;
  personal.nix.enable = true;
  personal.reverse-proxy.enable = true;
  # personal.clone-dotfiles.enable = true;
  personal.vm.enable = true;
  personal.cockpit.enable = true;
  personal.transmission.enable = true;
  personal.audio.enable = true;
  personal.users.enable = true;
  personal.console.enable = true;
  personal.avahi.enable = true;
  personal.localization.enable = true;
  personal.copySystemConfiguration.enable = true;
  personal.git-server.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh = {
    enable = true;
    ports = [ 22 2205 ];
  };

  environment.systemPackages = with pkgs; map lib.lowPrio [
    curl
    gitMinimal
    killall
  ];

  programs.sway = {
    enable = true;
  };

  programs.zsh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
