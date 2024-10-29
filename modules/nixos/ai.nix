{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

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
        host = "0.0.0.0";
        # acceleration = "cuda";
      };
      open-webui = {
        enable = true;
        openFirewall = true;
        host = "0.0.0.0";
        port = 7555;
        package = pkgs-stable.open-webui;
      };

      nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "ollama";
            port = "11434";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "open-webui";
            port = "7555";
          } //
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "scriberr";
            port = "4564";
          };
    };

    personal.docker-compose.scriberr = {
      stateDirectory.enable = true;

      env = {
        OPENAI_API_KEY = "";
        OPENAI_ENDPOINT = "http://host.docker.internal:11434";
        OPENAI_MODEL = "llama3.2";
      };

      file = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/rishikanthc/Scriberr/refs/tags/0.3.0/docker-compose.yaml";
        hash = "sha256-12ruGwRFxb6AMjlFleUPT/KPznfzJ2Yh7zc8eO6TSEQ=";
      };

      override = {
        name = "scriberr";
        services = {
          scriberr = {
            image = "ghcr.io/rishikanthc/scriberr:0.3.0";
            env_file = [
              ".env"
            ];
            ports = [
              "4564:3000" # Scriberr UI
              "4565:9243" # Optionally expose JobQueue UI
              "4567:8080" # Optionally expose Database Management UI
            ];
            volumes = [
              "/var/lib/scriberr:/scriberr"
              "/var/lib/scriberr/scriberr_pb_data:/app/db"
              "/var/lib/scriberr/models:/models"
            ];
            extra_hosts = [
              "host.docker.internal:host-gateway"
            ];
          };
          redis = {
            volumes = [
              "/var/lib/scriberr/redis:/data"
            ];
          };
          pocketbase = {
            ports = [
              "4566:8080" # Expose PocketBase on port 8080
            ];
            volumes = [
              "/var/lib/scriberr/pb_data:/pb/pb_data"
            ];
          };
        };
      };
    };
  };
}
