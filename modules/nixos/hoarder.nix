{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.hoarder;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.hoarder = {
    enable = mkEnableOption "hoarder";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts =
      createVirtualHosts
        {
          inherit nginxCfg;
          subdomain = "hoarder";
          port = "4561";
        };

    personal.docker-compose.hoarder = rec {
      stateDirectory.enable = true;

      env = {
        HOARDER_VERSION = "release";
        NEXTAUTH_SECRET = "klxV7lyDi5F6khdfJtStDxPBlNWgGQ++LKMFefPI/kypFmZQ";
        MEILI_MASTER_KEY = "klxV7lyDi5F6khdfJtStDxPBlNWgGQ++LKMFefPI/kypFmZQ";
        NEXTAUTH_URL = "http://localhost:3000";

        OLLAMA_BASE_URL = "http://localhost:11434";
        INFERENCE_TEXT_MODEL = "llama3.1:8b-text-q4_0";
        INFERENCE_IMAGE_MODEL = "llava:13b";
      };

      file = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/hoarder-app/hoarder/main/docker/docker-compose.yml";
        hash = "sha256-ivASIFOjLN2y/1DIh3KR3fE/8P4QGGS2fFuyM9X8FBI=";
      };

      override = {
        services.web = {
          ports = [
            "4561:3000"
          ];
          volumes = [
            "/var/lib/hoarder:/data"
          ];
        };
      };
    };
  };
}
