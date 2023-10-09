{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.javascript;
in
{
  options.personal.javascript = {
    enable = mkEnableOption "javascript";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      NODE_OPTIONS = "--openssl-legacy-provider"; # fix issue with openssl and nodejs
    };

    home.packages = with pkgs; [
      # (yarn.override { nodejs = nodejs-12_x; })
      # yarn
      nodejs
      # nodejs-14_x
      # nodejs-12_x
      deno
      bun
    ];
  };
}
