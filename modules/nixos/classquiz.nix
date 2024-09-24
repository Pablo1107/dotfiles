{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.classquiz;
  nginxCfg = config.personal.reverse-proxy;

  # Fetch the ClassQuiz repository from GitHub
  classquizRepo = pkgs.fetchFromGitHub {
    owner = "mawoka-myblock";
    repo = "classquiz";
    rev = "master";
    sha256 = "sha256-WE8ylg6K04ZhS3A69ILp78uwnIUUn4lSfucMgsOzTe4=";
  };
in
{
  options.personal.classquiz = {
    enable = mkEnableOption "classquiz";
  };

  config = mkIf cfg.enable {
    personal.docker-compose.classquiz = {
      stateDirectory.enable = true;

      env = {
        VITE_MAPBOX_ACCESS_TOKEN = "";  # Optional, leave empty if not using Mapbox
        VITE_HCAPTCHA = "";  # Replace with hCaptcha Sitekey if using captcha
        VITE_CAPTCHA_ENABLED = "false";  # Disable captcha since it's not needed
        VITE_SENTRY = "";  # Optional, leave empty if not using Sentry
        VITE_GOOGLE_AUTH_ENABLED = "false";  # Disable Google authentication
        VITE_GITHUB_AUTH_ENABLED = "false";  # Disable GitHub authentication
        STORAGE_BACKEND = "local";  # Use local storage for media
        STORAGE_PATH = "/var/lib/classquiz";  # Set the absolute path for local storage
        TOP_SECRET = "624e380541c63c62055143b239b78f5021fdb5cd87dc5d1a600d6798d0b9f24a";  # Replace with a secret key
        ROOT_ADDRESS = "https://quiz." + nginxCfg.localDomain;  # Set the root address
      };

      directory = "${classquizRepo}";

      override = {
        services.frontend = {
          build = {
            context = "${classquizRepo}/frontend";
          };
        };
        services.api = {
          build = {
            context = "${classquizRepo}";
          };
          environment = {
            VITE_MAPBOX_ACCESS_TOKEN = "";  # Optional, leave empty if not using Mapbox
            VITE_HCAPTCHA = "";  # Replace with hCaptcha Sitekey if using captcha
            VITE_CAPTCHA_ENABLED = "false";  # Disable captcha since it's not needed
            VITE_SENTRY = "";  # Optional, leave empty if not using Sentry
            VITE_GOOGLE_AUTH_ENABLED = "false";  # Disable Google authentication
            VITE_GITHUB_AUTH_ENABLED = "false";  # Disable GitHub authentication
            STORAGE_BACKEND = "local";  # Use local storage for media
            STORAGE_PATH = "/var/lib/classquiz";  # Set the absolute path for local storage
            TOP_SECRET = "624e380541c63c62055143b239b78f5021fdb5cd87dc5d1a600d6798d0b9f24a";  # Replace with a secret key
            ROOT_ADDRESS = "https://quiz." + nginxCfg.localDomain;  # Set the root address
          };
          volumes = [
            "\${STORAGE_PATH}/uploads/:/var/storage"
          ];
        };
        services.worker = {
          build = {
            context = "${classquizRepo}";
          };
        };
        services.proxy = {
          volumes = [
            "${classquizRepo}/Caddyfile-docker:/etc/caddy/Caddyfile"
          ];
          ports = [
            "9323:8080"
          ];
        };
      };
    };

    services.nginx.virtualHosts =
      createVirtualHosts
        {
          inherit nginxCfg;
          subdomain = "quiz";
          port = "9323";
        };

    # systemd.services."docker-compose-${classquiz}" = {
    #   serviceConfig = {
    #     # Stop services before in case they're running
    #     ExecStartPre = [
    #       (run "down")
    #       # Causes logspam on pull but shows more accurate activating info
    #       (run "create")
    #     ];
    #     ExecStart = run "up --quiet-pull --abort-on-container-exit";
    #
    #     ExecStop = run "down";
    #
    #     Restart = "on-failure";
    #
    #     # It may take >15 minutes to pull large images
    #     TimeoutStartSec = 1000;
    #
    #     StateDirectory = "classquiz";
    #   };
    #   # path = [ pkgs.docker ];
    #   #
    #   # requires = [ "docker.service" ];
    #   # wantedBy = [ "multi-user.target" ];
    # };
  };
}
