# based on
# https://github.com/Yash-Garg/dotfiles/blob/74b5e2eb37627380a0bbae469e5cdac73472cbe4/modules/nixos/services/paisa/default.nix#L13
{ config, options, lib, myLib, pkgs, inputs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.paisa;
  nginxCfg = config.personal.reverse-proxy;
  paisa-fhs = pkgs.buildFHSUserEnv {
    name = "paisa";
    targetPkgs =
      pkgs: with pkgs; [
        hledger
        inputs.paisa.packages.${pkgs.system}.default
      ];
    runScript = "paisa";
  };
in
{
  options.personal.paisa = {
    enable = mkEnableOption "paisa";

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to automatically open the necessary ports in the firewall.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/paisa";
      description = "Directory where paisa will create files.";
    };

    user = mkOption {
      type = types.str;
      default = "paisa";
      description = "The user which paisa will run on";
    };

    group = mkOption {
      type = types.str;
      default = "paisa";
      description = "The group of the user which paisa will run on";
    };

    port = mkOption {
      type = types.int;
      default = 7500;
      description = "The port for the webui";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ paisa-fhs ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.paisa-webui = {
      after = [ "network.target" ];
      description = "Paisa Web UI";
      wantedBy = [ "multi-user.target" ];
      path = [ paisa-fhs ];
      serviceConfig = {
        ExecStart = ''
          ${getExe paisa-fhs} serve \
            --port ${toString cfg.port}
        '';
        Restart = "on-success";
        User = cfg.user;
        Group = cfg.group;
      };
    };

    systemd.tmpfiles.rules = [ "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -" ];

    users.users = mkIf (cfg.user == "paisa") {
      paisa = {
        inherit (cfg) group;
        description = "Paisa Daemon user";
        home = cfg.dataDir;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "paisa") {
      paisa = {
        gid = null;
      };
    };

    services.nginx.virtualHosts =
      createVirtualHosts
        {
          inherit nginxCfg;
          subdomain = "paisa";
          port = "7500";
        };
  };
}
