{ modulesPath, config, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  personal.syncthing.enable = true;
  personal.immich.enable = true;
  personal.homepage-dashboard.enable = false;
  personal.ddns.enable = true;
  personal.nix.enable = true;
  personal.reverse-proxy.enable = true;
  # personal.clone-dotfiles.enable = true;
  personal.vm.enable = true;
  personal.cockpit.enable = false;
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
  personal.classquiz.enable = false;
  personal.ai.enable = true;
  personal.hoarder.enable = true;
  personal.gaming.enable = true;
  personal.dawarich.enable = false;
  personal.paisa.enable = false;
  personal.samba.enable = true;
  personal.nvidia.enable = true;
  personal.steam-headless.enable = false;
  personal.openiscsi.enable = true;
  personal.free-games-claimers.enable = false;
  personal.super-productivity.enable = true;
  personal.minecraft-servers.enable = false;
  personal.nh.enable = true;
  personal.gatus.enable = true;

  boot.extraModprobeConfig = ''
    # fix the F* keys on the Air75
    options hid_apple fnmode=0
  '';

  services.beesd.filesystems = {
    data = {
      spec = "/data";
      hashTableSizeMB = 2048;
      verbosity = "crit";
      extraOptions = [ "--loadavg-target" "5.0" ];
    };
  };

  programs.droidcam.enable = true;

  services.davfs2.enable = true;

  programs.java.enable = true;

  # personal.jovian.enable = true;
  # personal.access-point = {
  #   enable = false;
  # };

  programs.niri.enable = true;

  hardware.graphics.enable = true;

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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
    (wrapWine {
      name = "wrapWine";
      is64bits = true;
      tricks = [
        "dxvk"
        "xact"
        "xinput"
        "vcrun2022"
        "vkd3d"
        "corefonts"
        "win10"
        "mfc42"
        "vcrun6sp6"
        "corefonts"
      ];
    })
  ];

  services.xserver.desktopManager.xterm.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: with pkgs; [
        libsForQt5.full
      ];
    };
  };

  programs.sway = {
    enable = true;
  };
  programs.dconf.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  users.users.pablo.extraGroups = [ "wireshark" ];

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
