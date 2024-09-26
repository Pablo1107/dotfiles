{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.ai;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.ai = {
    enable = mkEnableOption "ai";
  };

  config = mkIf cfg.enable {
    services = {
      ollama = {
        enable = true;
        port = 11434;
        # acceleration = "cuda";
      };
      open-webui = {
        enable = true;
        openFirewall = true;
        host = "0.0.0.0";
        port = 7555;
      };

      nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "open-webui";
            port = "7555";
          };
    };
  };
}
