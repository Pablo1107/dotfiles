{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.console;
in
{
  options.personal.console = {
    enable = mkEnableOption "console";
  };

  config = mkIf cfg.enable {
    services.getty.greetingLine = ''
      Welcome to my Server!

      If you want to connect with this computer via SSH, you can use the following command:
      ssh root@${config.networking.hostName}.local

      IP Address: \4{enp4s0}
    '';
    environment.etc."issue.d/ip.issue".text = "\\4\n";
    networking.dhcpcd.runHook = "${pkgs.utillinux}/bin/agetty --reload";

    # Swap Caps with Escape
    services.xserver.xkb.options = "caps:swapescape";
    console.useXkbConfig = true;
  };
}
