{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.duckdns;
in
{
  options.personal.duckdns = {
    enable = mkEnableOption "duckdns";
  };

  config = mkIf cfg.enable {
    chaotic.duckdns = {
      enable = true;
      domain = "sagaro";
    };
  };
}
