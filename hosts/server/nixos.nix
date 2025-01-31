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
  personal.ddns.enable = true;
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
  personal.grocy.enable = true;
  personal.wireguard.enable = true;
  personal.ilv-map.enable = true;
  personal.vaultwarden.enable = true;
  personal.attic.enable = false;
  personal.uptime-kuma.enable = true;
  personal.classquiz.enable = true;
  personal.ai.enable = true;
  personal.hoarder.enable = true;
  personal.gaming.enable = true;
  personal.dawarich.enable = true;
  personal.paisa.enable = true;
  personal.samba.enable = true;
  personal.nvidia.enable = true;
  personal.steam-headless.enable = true;
  personal.openiscsi.enable = true;
  # personal.jovian.enable = true;

  services.flatpak.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services.fwupd.enable = true;

  services.gvfs.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.wireless.iwd.enable = true;
  networking.firewall.enable = false;
  services.openssh = {
    enable = true;
    ports = [ 22 2205 ];
    settings = {
      PasswordAuthentication = false;
    };
  };
  services.fail2ban = {
    enable = false;
    maxretry = 1;
    ignoreIP = [
      "192.168.0.0/16"
      "192.168.1.0/16"
    ];
    bantime = "1w";
  };

  environment.systemPackages = with pkgs; map lib.lowPrio [
    curl
    gitMinimal
    killall
    man-pages
    man-pages-posix
    gnome-software
    (steam.override {
      extraPkgs = pkgs: [
        libGLU
      ];
    })
  ];

  programs.sway = {
    enable = true;
  };
  programs.dconf.enable = true;

  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };

  programs.zsh.enable = true;


  system.stateVersion = "24.05";
}
