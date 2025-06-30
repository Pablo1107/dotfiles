{ config, options, lib, myLib, pkgs, pkgs-stable, ... }:

with lib;
with myLib;

let
  cfg = config.personal.free-games-claimers;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.free-games-claimers = {
    enable = mkEnableOption "free-games-claimers";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      free-games-claimer = {
        image = "ghcr.io/vogler/free-games-claimer:dev";
        #alwaysPull = true;
        volumes = [
         "/var/lib/fgc:/fgc/data"
        ];
        ports = [ "6080:6080" ];
        autoStart = true;
        extraOptions = [ "--rm" "-it" "--pull=always" ];
        environmentFiles = [
          "/etc/free-games-claimers.env"
        ];
        environment = {
          # PUID = config.tarow.stacks.defaultUid;
          # PGID = config.tarow.stacks.defaultGid;
          TZ = "America/Argentina/Buenos_Aires";
        };
        # cmd = [ "bash" "-c" "node epic-games; node prime-gaming; node gog; echo sleeping; sleep 1d" ];
        cmd = [ "bash" "-c" "node epic-games; echo sleeping; sleep 7d" ];
      };
    };

    # systemd.tmpfiles.settings.<config-name>.<path>.<tmpfiles-type>.mode
    systemd.tmpfiles.settings = {
      "var-lib-fgc"."/var/lib/fgc"."d".mode = "0755";
      "etc-free-games-claimers-env"."/etc/free-games-claimers.env"."f".mode = "0644";
    };
  };
}
