{ config, options, lib, inputs, pkgs, ... }:

with lib;

let
  cfg = config.personal.spicetify;
in
{
  options.personal.spicetify = {
    enable = mkEnableOption "spicetify";
  };

  config = mkIf cfg.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";

        enabledExtensions = with spicePkgs.extensions; [
          # fullAppDisplay
          # shuffle # shuffle+ (special characters are sanitized out of ext names)
          # hidePodcasts
        ];
      };
  };
}
