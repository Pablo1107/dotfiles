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

    # https://github.com/NixOS/nix/issues/8081#issuecomment-1962419263
    # https://discourse.nixos.org/t/ssl-ca-cert-error-on-macos/31171/6
    system.activationScripts."ssl-ca-cert-fix".text = ''
      if [ ! -f /etc/nix/ca_cert.pem ]; then
        security export -t certs -f pemseq -k /Library/Keychains/System.keychain -o /tmp/certs-system.pem
        security export -t certs -f pemseq -k /System/Library/Keychains/SystemRootCertificates.keychain -o /tmp/certs-root.pem
        cat /tmp/certs-root.pem /tmp/certs-system.pem > /tmp/ca_cert.pem
        sudo mv /tmp/ca_cert.pem /etc/nix/
      fi
    '';

    nix.settings = {
      ssl-cert-file = "/etc/nix/ca_cert.pem";
    };
  };
}
