{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.ssh;
in
{
  options.personal.ssh = {
    enable = mkEnableOption "ssh";
    withAuthorizationKeys = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Adds the authorization keys to the correct file
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host github.com
        Hostname ssh.github.com
        Port 443

        Host gitlab.com
        Hostname altssh.gitlab.com
        Port 443
      '';
    };


    home.persistence."${config.home.homeDirectory}/dotfiles/config" = mkIf cfg.withAuthorizationKeys {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "ssh/.ssh/authorized_keys"
      ];
    };
  };
}
