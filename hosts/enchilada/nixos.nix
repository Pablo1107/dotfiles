{ modulesPath, inputs, config, pkgs, lib, ... }:

{

  imports = [
    # Minimize the build to produce a smaller closure
    "${modulesPath}/profiles/minimal.nix"
  ];

  # personal.clone-dotfiles.enable = true;

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
    networkmanager.enable = false;
    hostName = "enchilada";
    wireless = {
      enable = true;
      networks."Personal-395".psk = "2Dw49D7Rgz";
    };
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  services.xserver.desktopManager.phosh = {
    enable = true;
    user = "default";
    group = "users";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  zramSwap.enable = true;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-console
    vim
    git
  ];

  users = {
    mutableUsers = false;
    users.pablo = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$OS4NK14ShiPQoRbXEP2V40$YK3Wj2tcDV7Sk0/vx79sm6VMJ.SAfhuNh85gozlhZy7";
      extraGroups = [
        "dialout"
        "feedbackd"
        "networkmanager"
        "video"
        "wheel"
      ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNkVRNIPtgFH7+bW6LENpR6EmWoNjGDmKXoVj2zM69e pablo@nixos
"
        ];
      };
    };
  };

  nix = {
    settings = {
      trusted-users = [ "@wheel" "root" "pablo" ];
      experimental-features = [ "nix-command" "flakes" ];
      builders-use-substitutes = true;
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      trust-tarballs-from-git-forges = true;
    };
    package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = lib.mkForce inputs.nixpkgs;
    registry.nixpkgs.to.path = lib.mkForce inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  # hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";
}
