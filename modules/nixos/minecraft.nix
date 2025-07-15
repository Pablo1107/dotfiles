{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

with lib;
with myLib;

let
  cfg = config.personal.minecraft-servers;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.minecraft-servers = {
    enable = mkEnableOption "minecraft-servers";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts =
        createVirtualHosts
          {
            inherit nginxCfg;
            subdomain = "mc";
            port = "25565";
          };

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      dataDir = "/var/lib/minecraft-servers";
      servers.fabric = {
        enable = true;

        # Specify the custom minecraft server package
        package = pkgs.fabricServers.fabric-1_21_1.override {
          loaderVersion = "0.16.10";
        }; # Specific fabric loader version

        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (
            builtins.attrValues {
              Fabric-API = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/9YVrKY0Z/fabric-api-0.115.0%2B1.21.1.jar";
                sha512 = "e5f3c3431b96b281300dd118ee523379ff6a774c0e864eab8d159af32e5425c915f8664b1";
              };
              Backpacks = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/MGcd6kTf/versions/Ci0F49X1/1.2.1-backpacks_mod-1.21.2-1.21.3.jar";
                sha512 = "6efcff5ded172d469ddf2bb16441b6c8de5337cc623b6cb579e975cf187af0b79291";
              };
            }
          );
        };
      };
    };

    # Ensure the state directory exists
    # systemd.tmpfiles.rules = [
    #   "d ${cfg.stateDir} 0755 root root - - -"
    #   "f ${cfg.stateDir}/webdav/config.yaml 0644 root root - - -"
    #   "d ${cfg.stateDir}/webdav/data 0755 root root - - -"
    #   "d ${cfg.stateDir}/webdav/sync 0755 root root - - -"
    # ];
  };
}
