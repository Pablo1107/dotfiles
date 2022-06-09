{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.ssh;
in
{
  options.personal.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host github.com
        Hostname ssh.github.com
        Port 443
      '';
    };
  };
}
