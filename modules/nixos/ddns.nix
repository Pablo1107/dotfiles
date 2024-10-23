{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.ddns;
in
{
  options.personal.ddns = {
    enable = mkEnableOption "ddns";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfdyndns
    ];

    # cloudflare
    services.cfdyndns = {
      enable = true;
      records = [ "sagaro.fun" ];
      apiTokenFile = "/etc/cfdyndns.env";
    };

    # fallback
    chaotic.duckdns = {
      enable = true;
      domain = "sagaro";
    };
  };
}
