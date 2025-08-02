{ config, options, lib, myLib, pkgs-stable, ... }:

with lib;

let
  cfg = config.personal.daw;
in
{
  options.personal.daw = {
    enable = mkEnableOption "daw";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs-stable; [
      # (myLib.nixGLWrapper pkgs-stable {
      #   bin = "bitwig-studio";
      # })
      bitwig-studio
      amplitube5
      abpl
      moises-desktop # for isolating instruments
    ];

    personal.yabridge = {
      enable = true;
      plugin_dirs = [
        "/home/pablo/.wine-nix/amplitube5/drive_c/Program Files/Common Files/VST3"
        "/home/pablo/.wine-nix/amplitube5/drive_c/Program Files/Steinberg/VSTPlugins"
        "/home/pablo/.wine-nix/helix-native-3_60_0/drive_c/Program Files/Common Files/VST3"
        "/home/pablo/.wine-nix/abpl/drive_c/Program Files/Steinberg/VSTPlugins"
      ];
    };
  };
}

# instructions for amplitube5:
# yabridgectl add /home/pablo/.wine-nix/amplitube5/drive_c/Program\ Files/Common\ Files/VST3/
# yabridgectl sync
