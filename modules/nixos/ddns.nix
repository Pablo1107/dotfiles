{ config, options, lib, pkgs, inputs, ... }:

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
        inputs.secrets.domains."5ab27717-dffb-4770-a992-7b3681760c2e"
        "immich-pp.${inputs.secrets.domains."5ab27717-dffb-4770-a992-7b3681760c2e"}"
      ];
      apiTokenFile = "/etc/cfdyndns.env";
    };

    # fallback
    # chaotic.duckdns = {
    #   enable = true;
    #   domain = "sagaro";
    # };
  };
}
