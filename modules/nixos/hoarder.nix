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

    services.gatus.settings.endpoints = [{
      name = "Hoarder";
      url = "https://hoarder." + nginxCfg.localDomain;
      interval = "5m";
      conditions = [
        "[STATUS] == 200"
        "[RESPONSE_TIME] < 300"
      ];
    }];

    personal.docker-compose.hoarder = rec {
      stateDirectory.enable = true;

      env = {
        HOARDER_VERSION = "release";
        NEXTAUTH_SECRET = "klxV7lyDi5F6khdfJtStDxPBlNWgGQ++LKMFefPI/kypFmZQ";
        MEILI_MASTER_KEY = "klxV7lyDi5F6khdfJtStDxPBlNWgGQ++LKMFefPI/kypFmZQ";
        NEXTAUTH_URL = "http://localhost:3000";

        OLLAMA_BASE_URL = "http://host.docker.internal:11434";
        INFERENCE_TEXT_MODEL = "mistral";
        INFERENCE_IMAGE_MODEL = "llava";
        INFERENCE_JOB_TIMEOUT_SEC = "60";
      };

      file = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/hoarder-app/hoarder/main/docker/docker-compose.yml";
        hash = "sha256-ivASIFOjLN2y/1DIh3KR3fE/8P4QGGS2fFuyM9X8FBI=";
      };

      override = {
        name = "hoarder";
        services.web = {
          ports = [
            "4561:3000"
          ];
          volumes = [
            "/var/lib/hoarder:/data"
          ];
          extra_hosts = [
            "host.docker.internal:host-gateway"
          ];
        };
      };
    };
  };
}
