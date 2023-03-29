{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.emacs;
in
{
  options.personal.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    services.emacs = {
      enable = true;
      package = pkgs.emacsPgtk;
      # hardcoded because I don't find any other solution so far
      additionalPath = [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "${config.users.users.pablo.home}/.nix-profile/bin"
        "/etc/profiles/per-user/pablo/bin"
        "/run/current-system/sw/bin"
        "/nix/var/nix/profiles/default/bin"
        "${config.users.users.pablo.home}/dotfiles/bin"
        "${config.users.users.pablo.home}/scripts"
        "${config.users.users.pablo.home}/.local/bin/"
        "${config.users.users.pablo.home}/.emacs.d/bin"
        "${config.users.users.pablo.home}/.npm-packages/bin"
      ];
    };

    # rest of the config is in home manager
  };
}
