{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.homebrew;
in
{
  options.personal.homebrew = {
    enable = mkEnableOption "homebrew";
  };

  config = mkIf cfg.enable {
    system.activationScripts.homebrew.text = ''
      # Check to see if Homebrew is installed, and install it if it is not
      if [ -f "${config.homebrew.brewPrefix}/brew" ]; then
        echo "Homebrew is installed, skipping..." >&2
      else
        echo "Installing Homebrew Now" >&2
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    '';

    homebrew = {
      enable = true;
      cleanup = "uninstall";
      taps = [
        "homebrew/cask"
        "homebrew/services"
      ];
      brews = [
        "pkg-config"
        "pixman"
        "cairo"
        "pango"
        "syncthing"
      ];
      casks = [
        "firefox"
        "zoom"
        "google-chrome"
        "chromium"
        "insomnia"
        "docker"
        "spotify"
        "alacritty"
        "telegram"
        "whatsapp"
        "dbeaver-community"
        "steam"
        "netnewswire"
      ];
    };
  };
}
