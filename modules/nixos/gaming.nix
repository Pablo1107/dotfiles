{ config, options, lib, myLib, pkgs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.gaming;
  # nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.gaming = {
    enable = mkEnableOption "gaming";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      (lutris.override {
        extraLibraries = pkgs: [
          libgudev
          speex
          libvdpau
          libusb1
          gst_all_1.gst-plugins-bad
        ];
        extraPkgs = pkgs: [
          wineWowPackages.waylandFull
          pango
        ];
      })
      wineWowPackages.waylandFull
    ];
    programs.steam.enable = true;
    # programs.nix-ld = {
    #   enable = true;
    #   libraries = with pkgs; [
    #     openldap24
    #     libGLU
    #   ] ++ (pkgs.steam-run.fhsenv.args.multiPkgs pkgs);
    # };
  };
}
