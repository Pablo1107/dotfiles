{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.vifm;
in
{
  options.personal.vifm = {
    enable = mkEnableOption "vifm";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vifm
      kitty # for icat kitten previews
    ];

    home.persistence."${config.home.homeDirectory}/dotfiles/config" = {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "vifm/.config/vifm"
      ];
      # directories = [
      #   "vifm/.config/vifm"
      # ];
    };

    # home.file.".config/vifm/vifmrc".text = myLib.getDotfile "vifm" "vifmrc";
    # home.file.".config/vifm/colors/solarized-dark.vifm".text = getDotfile "vifm" "colors/solarized-dark.vifm";
  };
}
