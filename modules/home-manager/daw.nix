{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.daw;
in
{
  options.personal.daw = {
    enable = mkEnableOption "daw";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      amplitube5
      yabridge
      yabridgectl
    ];
  };
}

# instructions for amplitube5:
# yabridgectl add /home/pablo/.wine-nix/amplitube5/drive_c/Program\ Files/Common\ Files/VST3/
# yabridgectl sync
