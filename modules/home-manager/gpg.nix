{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.gpg;
in
{
  options.personal.gpg = {
    enable = mkEnableOption "gpg";

    pinentry-program = mkOption {
      default = pkgs.pinentry_mac;
      type = types.attrs;
      description = "Pinentry program for decrypting GPG keys.";
    };

    pinentry-program-bin = mkOption {
      default = "${cfg.pinentry-program}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
      type = types.path;
      description = "Bin to use for pinentry. Should be consistent with pinentry-program option.";
    };
  };

  config = mkIf cfg.enable {
    # stolen from https://github.com/landakram/nix-config/blob/5439a42d20eecea5333dceb020557c95becbef56/modules/gpg/default.nix#L18

    programs.gpg = {
      enable = true;
      # settings = {
      #   default-key = cfg.default-key;
      #   keyid-format = "LONG";
      #   keyserver = "hkp://keys.gnupg.net";
      #   keyserver-options = "auto-key-retrieve";
      #   auto-key-locate = "cert pka ldap hkp://keys.gnupg.net";
      # };
    };

    home.packages = [
      cfg.pinentry-program
    ];

    home.file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${cfg.pinentry-program-bin}
      default-cache-ttl 2400
      max-cache-ttl 7200
    '';
  };
}
