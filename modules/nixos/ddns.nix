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
    services.cloudflare-dyndns = {
      enable = true;
      domains = [
        "sagaro.fun"
        "immich-pp.sagaro.fun"
      ];
      apiTokenFile = "/etc/cfdyndns.env";
    };

    # fallback
    chaotic.duckdns = {
      enable = true;
      domain = "sagaro";
    };
  };
}
