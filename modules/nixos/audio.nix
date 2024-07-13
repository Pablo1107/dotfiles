{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.audio;
in
{
  options.personal.audio = {
    enable = mkEnableOption "audio";
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      # systemWide = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };

    hardware.pulseaudio.enable = lib.mkForce false;

    users.users.pablo.extraGroups = [ "pipewire" "audio" ];

    security.rtkit.enable = true; # Required for low-latency audio
    powerManagement.cpuFreqGovernor = "performance";
    boot.kernelParams = [ "threadirqs" ];
    security.pam.loginLimits = [
      {
        domain = "@audio";
        type = "hard";
        item = "rtprio";
        value = "95";
      }
      {
        domain = "@audio";
        type = "soft";
        item = "rtprio";
        value = "95";
      }
      {
        domain = "@audio";
        type = "hard";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "@audio";
        type = "soft";
        item = "memlock";
        value = "unlimited";
      }
    ];
  };
}
