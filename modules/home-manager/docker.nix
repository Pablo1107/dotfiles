{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.docker;

  DOCKER_CONFIG = "${config.home.homeDirectory}/.docker/config.json";
  DOCKER_SETTINGS = "${config.home.homeDirectory}/Library/Group Containers/group.com.docker/settings.json";
in
{
  options.personal.docker = {
    enable = mkEnableOption "docker";
  };

  config = mkIf cfg.enable {
    home.activation.dockerSettings = lib.hm.dag.entryAnywhere ''
      cat <<< "$(jq '. + {credHelpers: {"'"288621255955.dkr.ecr.us-east-1.amazonaws.com"'": "'"ecr-login"'"}}' "${DOCKER_CONFIG}")" > "${DOCKER_CONFIG}"
      cat <<< "$(jq '. + {cpus: 6, memoryMiB: 8192, swapMiB: 512, kubernetesEnabled: true, showKubernetesSystemContainers: true}' "${DOCKER_SETTINGS}")" > "${DOCKER_SETTINGS}"
    '';
  };
}

