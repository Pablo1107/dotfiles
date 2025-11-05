{ config, options, lib, pkgs, pkgs-patched, ... }:

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
      (python3.withPackages (ps: with ps; [
        llm
        llm-ollama
      ]))
      pkgs-patched.opencode
    ];
    # home.sessionVariables = {
    #   LOCAL_AI_API_HOST = "http://t14s.local:8080";
    #   DEFAULT_MODEL = "stablebeluga-13b.ggmlv3.q6_K.bin";
    # };
  };
}

