{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.ai;
in
{
  options.personal.ai = {
    enable = mkEnableOption "ai";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      local-ai
      local-shell-gpt
    ];
    home.sessionVariables = {
      LOCAL_AI_HOST = "http://localhost:8000";
      DEFAULT_MODEL = "ggml-gpt4all-j";
    };
    systemd.user.services.local-ai = {
      Unit = {
        Description = "Local AI Service";
      };

      Service = {
        ExecStart = "${pkgs.local-ai}/bin/local-ai";
        WorkingDirectory = "${config.home.homeDirectory}/.local/share/local-ai";
        Restart = "on-failure";
      };

      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}

