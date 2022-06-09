{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.xdg;
in
{
  options.personal.xdg = {
    enable = mkEnableOption "xdg";
  };

  config = mkIf cfg.enable {
    xdg = {
      userDirs = {
        enable = true;
        desktop = "\$HOME/desktop";
        documents = "\$HOME/docs";
        download = "\$HOME/downloads";
        music = "\$HOME/music";
        pictures = "\$HOME/pictures";
        videos = "\$HOME/videos";
        publicShare = "\$HOME/desktop/public";
        templates = "\$HOME/desktop/templates";
      };
    };
    xdg.configFile."mimeapps.list".force = true;
    xdg.dataFile."applications/mimeapps.list".force = true;
    xdg.mime.enable = true;
    xdg.mimeApps = {
      enable = true;
      # query mime type from a file like this:
      # xdg-mime query filetype your-file.extension
      # also check out:
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
      defaultApplications = {
        "application/json" = [ "firefox.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];
        "application/x-bittorrent" = [ "org.qbittorrent.qBittorrent.desktop" ];
        "application/x-shellscript" = [ "nvim.desktop" ];
        "application/x-xpinstall" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "text/english" = [ "nvim.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "text/plain" = [ "nvim.desktop" ];
        "text/x-c" = [ "nvim.desktop" ];
        "text/x-c++" = [ "nvim.desktop" ];
        "text/x-c++hdr" = [ "nvim.desktop" ];
        "text/x-c++src" = [ "nvim.desktop" ];
        "text/x-chdr" = [ "nvim.desktop" ];
        "text/x-csrc" = [ "nvim.desktop" ];
        "text/x-java" = [ "nvim.desktop" ];
        "text/x-makefile" = [ "nvim.desktop" ];
        "text/x-moc" = [ "nvim.desktop" ];
        "text/x-pascal" = [ "nvim.desktop" ];
        "text/x-tcl" = [ "nvim.desktop" ];
        "text/xml" = [ "firefox.desktop" ];
        "image/bmp" = [ "org.gnome.eog.desktop" ];
        "image/g3fax" = [ "gimp.desktop" ];
        "image/gif" = [ "org.gnome.eog.desktop" ];
        "image/jpeg" = [ "org.gnome.eog.desktop" ];
        "image/jpg" = [ "org.gnome.eog.desktop" ];
        "image/pjpeg" = [ "org.gnome.eog.desktop" ];
        "image/png" = [ "org.gnome.eog.desktop" ];
        "image/svg+xml" = [ "org.gnome.eog.desktop" ];
        "image/svg+xml-compressed" = [ "org.gnome.eog.desktop" ];
        "image/tiff" = [ "org.gnome.eog.desktop" ];
        "image/webp" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/eclipse+command" = [ "dbeaver.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/magnet" = [ "org.qbittorrent.qBittorrent.desktop" ];
        "x-scheme-handler/postman" = [ "Postman.desktop" ];
        "x-scheme-handler/slack" = [ "slack.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
    };
  };
}
