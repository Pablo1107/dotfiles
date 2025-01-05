{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.samba;
in
{
  options.personal.samba = {
    enable = mkEnableOption "samba";
  };

  config = mkIf cfg.enable {
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0.0/16 127.0.0.1 localhost 10.100.0.0/16";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "private" = {
          "path" = "/data/";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "pablo";
          "force group" = "users";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    services.avahi = {
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
      nssmdns4 = true;
      # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
      enable = true;
      openFirewall = true;
    };

    # networking.firewall.enable = true;
    # networking.firewall.allowPing = true;
  };
}
