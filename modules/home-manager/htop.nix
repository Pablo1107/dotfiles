{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.htop;
in
{
  options.personal.htop = {
    enable = mkEnableOption "htop";
  };

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      settings = {
        hideThreads = true;
        hideUserlandThreads = true;
        showCpuUsage = true;
        showProgramPath = false;
        vimMode = true;
        fields = with config.lib.htop.fields; [
          PID
          USER
          PRIORITY
          NICE
          M_SIZE
          M_RESIDENT
          M_SHARE
          STATE
          PERCENT_CPU
          PERCENT_MEM
          TIME
          COMM
        ];
        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;
      } // (with config.lib.htop; leftMeters [
        (bar "LeftCPUs2")
        (bar "Memory")
        (bar "Swap")
      ]) // (with config.lib.htop; rightMeters [
        (bar "RightCPUs2")
        (text "Tasks")
        (text "LoadAverage")
      ]);
    };
  };
}

