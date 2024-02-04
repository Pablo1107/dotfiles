{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.clone-dotfiles;
in
{
  options.personal.clone-dotfiles = {
    enable = mkEnableOption "clone-dotfiles";
  };

  config = mkIf cfg.enable {
    system.userActivationScripts.cloneDotfilesRepo.text = ''
      # optionally check if the current user id is the one of tomato, as this runs for every user
      [ ! -f "~/dotfiles/flake.nix" ] && rm -rf ~/dotfiles ; ${pkgs.git}/bin/git clone https://github.com/Pablo1107/dotfiles ~/dotfiles
      # optionally git pull to keep them up to date
    '';
  };
}
