{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.npm;

  NPM_PACKAGES = "$HOME/.npm-packages";
in
{
  options.personal.npm = {
    enable = mkEnableOption "npm";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      inherit NPM_PACKAGES;
      MANPATH = "\${MANPATH-$(manpath)}:${NPM_PACKAGES}/share/man";
    };
    home.sessionPath = [
      "${NPM_PACKAGES}/bin"
    ];
  };
}
