# stolen from https://github.com/azuwis/nix-config/blob/513a3393406a0ca2a4f186e3d9428351e025531d/modules/sketchybar/default.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.sketchybar;

  # configHome = pkgs.writeTextFile {
  #   name = "sketchybarrc";
  #   text = cfg.config;
  #   destination = "/sketchybar/sketchybarrc";
  #   executable = true;
  # };
in
{
  options.personal.sketchybar = with types; {
    enable = mkEnableOption "sketchybar";

    package = mkOption {
      type = path;
      description = "The sketchybar package to use.";
      default = pkgs.sketchybar;
    };

    config = mkOption {
      type = str;
      example = literalExpression ''
        sketchybar -m --bar height=25
        echo "sketchybar configuration loaded.."
      '';
      description = "Configuration";
    };

    height = mkOption {
      type = int;
      default = 32;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.sketchybar = {
      serviceConfig.ProgramArguments = [ "${cfg.package}/bin/sketchybar" ];

      serviceConfig.KeepAlive = true;
      serviceConfig.RunAtLoad = true;
      serviceConfig.EnvironmentVariables = {
        PATH = "${cfg.package}/bin:${config.environment.systemPath}";
        # XDG_CONFIG_HOME = mkIf (cfg.config != "") "${configHome}";
      };
    };
  };
}
