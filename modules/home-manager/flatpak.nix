{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

with lib;

let
  cfg = config.personal.gui;
in
{
  options.personal.flatpak = {
    enable = mkEnableOption "gui";
  };


  config = mkIf cfg.enable {
    # Add a new remote. Keep the default one (flathub)
    # services.flatpak.remotes = lib.mkOptionDefault [{
    #   name = "flathub-beta";
    #   location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    # }];

    services.flatpak.update.auto.enable = true;
    services.flatpak.uninstallUnmanaged = true;

    # Add here the flatpaks you want to install
    services.flatpak.packages = [
      "app.zen_browser.zen"
      "com.stremio.Stremio"
      "io.github.glaumar.QRookie"
      "com.github.tchx84.Flatseal"
      #{ appId = "com.brave.Browser"; origin = "flathub"; }
      #"com.obsproject.Studio"
      #"im.riot.Riot"
    ];
  };
}
