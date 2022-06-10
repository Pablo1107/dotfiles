{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.firefox;

  userChrome = myLib.getDotfile "firefox" "chrome/userChrome.css";
  userContent = myLib.getDotfile "firefox" "chrome/userContent.css";

  customFirefox = (
    pkgs.firefox-wayland.override {
      extraPrefs = ''
        //  
        var {classes:Cc,interfaces:Ci,utils:Cu} = Components;  
              
        /* set new tab page */  
        try {  
          Cu.import("resource:///modules/AboutNewTab.jsm");  
          var newTabURL = "file:////home/pablo/index.html";  
          AboutNewTab.newTabURL = newTabURL;  
        } catch(e){Cu.reportError(e);} // report errors in the Browser Console
      '';
    }
  ).overrideAttrs (
    oldAttrs: {
      buildCommand = oldAttrs.buildCommand + ''
        echo 'pref("general.config.sandbox_enabled", false);' >> "$out/lib/firefox/defaults/pref/autoconfig.js"
      '';
      mozillaCfg = pkgs.writeText "mozilla.cfg" ''
          '';
    }
  );

  firefoxNixGL = pkgs.makeDesktopItem {
    name = "firefox-nixgl";
    exec = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${customFirefox}/bin/firefox %U";
    icon = "${customFirefox}/share/icons/hicolor/64x64/apps/firefox.png";
    comment = "";
    desktopName = "Firefox";
    genericName = "Web Browser";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };
in
{
  options.personal.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      firefoxNixGL
    ];

    programs.firefox = {
      enable = true;
      package = customFirefox;
      profiles =
        let
          defaultSettings = {
            "browser.aboutConfig.showWarning" = false;
            "browser.startup.page" = 3;
            "browser.tabs.insertAfterCurrent" = true;
            "browser.tabs.tabMinWidth" = 200;
            "browser.uidensity" = 1;
            "devtools.theme" = "dark";
            "gfx.webrender.all" = true;
            "gfx.webrender.enabled" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "ui.systemUsesDarkTheme" = 1;
          };
        in
        {
          pablo = {
            id = 0;
            settings = defaultSettings;
            inherit userChrome userContent;
          };
        };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        privacy-badger
        multi-account-containers
        https-everywhere
        darkreader
      ];
    };
  };
}
