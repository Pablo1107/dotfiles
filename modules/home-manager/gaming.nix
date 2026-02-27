{ config, options, lib, pkgs, pkgs-patched, ... }:

with lib;

let
  cfg = config.personal.gaming;
in
{
  options.personal.gaming = {
    enable = mkEnableOption "gaming";
  };

  config = mkIf cfg.enable {
    # SteamVR not installing correctly desktop files
    xdg.desktopEntries = {
      valve-URI-steamvr = {
        name = "URI-steamvr";
        comment = "URI handler for steamvr://";
        exec = "\"${config.home.homeDirectory}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrurlhandler\" %U";
        terminal = false;
        type = "Application";
        categories = [ "Game" ];
        mimeType = [ "x-scheme-handler/steamvr" ];
      };

      valve-URI-vrmonitor = {
        name = "URI-vrmonitor";
        comment = "URI handler for vrmonitor://";
        exec = "\"${config.home.homeDirectory}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/../vrmonitor.sh\" %U";
        terminal = false;
        type = "Application";
        categories = [ "Game" ];
        mimeType = [ "x-scheme-handler/vrmonitor" ];
      };
    };
  };
}

