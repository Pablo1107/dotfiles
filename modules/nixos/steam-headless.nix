# based on https://github.com/christian-blades-cb/dots/blob/55036e3a642a8aba3c10ee2342424581bf350a15/nixos/steam-headless-container.nix#L44
{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

with lib;
with myLib;

let
  cfg = config.personal.steam-headless;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.steam-headless = {
    enable = mkEnableOption "steam-headless";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts = createVirtualHosts {
      inherit nginxCfg;
      subdomain = "steam";
      port = "8083";
    };

    users.users.steam-headless = {
      uid = 600;
      isSystemUser = true;
      group = "steam-headless";
      extraGroups = [ "audio" "video" "input" "uinput" ];
    };

    users.groups.steam-headless = {
      gid = 600;
    };

    virtualisation.oci-containers.containers.steam-headless = let
      SERVICE_PATH = "/var/lib/steam-headless";
      NAME = "steam-headless";
    in {
      image = "josh5/steam-headless:latest";

      # lol, --network=host because I can't be bothered to find all the ports anymore
      ports = [

      ];

      hostname = NAME;

      extraOptions = [
        # "--gpus=all"
        "--device=nvidia.com/gpu=all"
        "--security-opt=apparmor=unconfined"
        "--security-opt=seccomp=unconfined"
        "--device=/dev/uinput"
        "--device=/dev/fuse"
        "--device-cgroup-rule=c 13:* rmw"
        "--cap-add=NET_ADMIN"
        "--cap-add=SYS_ADMIN"
        "--cap-add=SYS_NICE"
        "--ipc=host"
        "--add-host=${NAME}:127.0.0.1"
        "--network=host"
      ];

      volumes = [
        "${SERVICE_PATH}/home/:/home/default:rw"
        "${SERVICE_PATH}/.X11-unix/:/tmp/.X11-unix:rw"
        "${SERVICE_PATH}/pulse/:/tmp/pulse:rw"
        "/shared:/mnt/games:rw"
        "/dev/input:/dev/input:rw"
      ];

      # https://github.com/Steam-Headless/docker-steam-headless/blob/master/docs/compose-files/.env
      environment = {
        inherit NAME;
        TZ = "America/Argentina/Buenos_Aires";
        USER_LOCALES = "en_US.UTF-8 UTF-8";
        DISPLAY = ":55";
        MODE = "primary";
        WEB_UI_MODE = "vnc";
        ENABLE_VNC_AUDIO = "true";
        PORT_NOVNC_WEB = "8083";
        ENABLE_STEAM = "true";
        #STEAM_ARGS = "-silent -bigpicture";
        ENABLE_SUNSHINE = "true";
        SUNSHINE_USER = "sunshine";
        SUNSHINE_PASS = "sunshine";
        ENABLE_EVDEV_INPUTS = "true";
        NVIDIA_DRIVER_CAPABILITIES = "all";
        NVIDIA_VISIBLE_DEVICES = "all";

        PUID = "600";
        PGID = "600";
        UMASK = "000";
        USER_PASSWORD = "password";
      };
    };

    # BEWARE: here's where I gave up guessing which ports it was going to listen on
    networking.firewall.enable = false;

    networking.firewall.allowedTCPPorts = [
      7860 5900 8083
      32036 32037 32041
      47984 47989 47990 48010
    ];

    services.udev.extraRules = ''
        KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    '';

    # this container expects some host directories to exist for persistence, let's automate that
    systemd.services.steam-headless-init = {
      enable = true;

      wantedBy = [
        "${config.virtualisation.oci-containers.backend}-steam-headless.service"
      ];

      script = ''
        umask 077
        mkdir -p /var/lib/steam-headless/{home,.X11-unix,pulse}
        umask 066
      '';

      serviceConfig = {
        User = "steam-headless";
        Group = "steam-headless";
        Type = "oneshot";
        RemainAfterExit = true;
        StateDirectory = "steam-headless";
        StateDirectoryMode = "0700";
      };
    };
  };
}
