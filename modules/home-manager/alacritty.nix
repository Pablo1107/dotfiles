{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.alacritty;
in
{
  options.personal.alacritty = {
    enable = mkEnableOption "alacritty";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
    ];

    home.persistence."${config.home.homeDirectory}/dotfiles/config" = {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "alacritty/.config/alacritty/alacritty.yml"
      ];
    };
  };
}
