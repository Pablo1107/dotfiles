{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.one;
in
{
  options.personal.one = {
    enable = mkEnableOption "one";
  };

  config = mkIf cfg.enable {
    homebrew = {
      taps = [
        "homebrew/cask-fonts"
      ];
      brews = [
        # Organization wide packages
        # "coreutils"
        # "git"
        # "gnupg"
        # "jq"
        "kubectx"
        "kubernetes-cli"
        # "make"
        "pinentry-mac"
        # "tmux"
        # "tree"
        # "watch"
        # "wget"
        # "helm"
        "stern"
        "vault"
        "yq" # possible installed by nix
        # python3

        # Safe API Requirements
        "cairo"

        # "mysql@5.7"
        {
          name = "mysql@5.7";
          restart_service = true;
          link = true;
          conflicts_with = [ "mysql" ];
        }

        "pango"
        "redis"
        "skaffold"
        "pkg-config"
        "libpng"
        "jpeg"
        "giflib"
        "librsvg"
        "pixman"
      ];
      casks = [
        # Organization wide packages
        "font-dejavu"
      ];
    };
  };
}
