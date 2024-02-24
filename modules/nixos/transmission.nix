{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.transmission;
in
{
  options.personal.transmission = {
    enable = mkEnableOption "transmission";
  };

  config = mkIf cfg.enable {
    services.transmission = {
      enable = true; #Enable transmission daemon
      openRPCPort = true; #Open firewall for RPC
      settings = {
        rpc-authentication-required = false;
        rpc-bind-address = "0.0.0.0";
        rpc-host-whitelist-enabled = false;
        rpc-whitelist-enabled = false;
        rpc-port = 9091;
      };
    };

    users.users.pablo.extraGroups = [ "transmission" ];
  };
}
