{ modulesPath, inputs, config, pkgs, lib, ... }:

let
  # gnome-extensions = with pkgs.gnomeExtensions; [
  #   screen-rotate
  # ];
in
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
    networkmanager = {
      enable = true;
      ensureProfiles.profiles = {
        my-cool-wifi = {
          connection = {
            id = "some-wifi-id";
            type = "wifi";
            interface = "wlan0";
            permissions = "";
          };
          ipv4 = {
            method = "auto";
            dns = "8.8.8.8";
            dns-search = "";
          };

          wifi = {
            mode = "infrastructure";
            ssid = "Personal-395";
          };

          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "2Dw49D7Rgz";
          };
        };
      };
    };
    hostName = "enchilada";
    # wireless = {
    #   enable = true;
    #   networks."Personal-395".psk = "2Dw49D7Rgz";
    # };
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

  # services.xserver.enable = true;
  # services.xserver.displayManager = {
  #   sddm.enable = true;
  #   autoLogin = {
  #     enable = true;
  #     user = "pablo";
  #   };
  #   defaultSession = "plasma-mobile";
  # };
  # services.xserver.desktopManager.plasma5 = {
  #   enable = true;
  #   mobile.enable = true;
  #   mobile.installRecommendedSoftware = true;
  # };

  # services.xserver.desktopManager.phosh = {
  #   enable = true;
  #   user = "pablo";
  #   group = "users";
  # };
  # services.gnome.gnome-keyring.enable = true;

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
    firefox
  ];

  # programs.dconf = {
  #   enable = true;
  #   profiles.user.databases = [{
  #     settings = with lib.gvariant; {
  #       "org/gnome/shell" = {
  #         enabled-extensions =
  #           builtins.map
  #             (x: x.extensionUuid)
  #             (lib.filter (p: p ? extensionUuid) gnome-extensions);
  #       };
  #     };
  #   }];
  # };

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
      # flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
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
