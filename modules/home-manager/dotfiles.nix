{ config, lib, ... }:

with lib;

{
  options.personal.dotfiles = {
    path = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/dotfiles";
      description = "Path to the dotfiles directory.";
    };
  };
}
