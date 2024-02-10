{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.vm;
in
{
  options.personal.vm = {
    enable = mkEnableOption "vm";

    bridgeInterface = mkOption {
      type = types.str;
      default = "br0";
    };

    ethInterface = mkOption {
      type = types.str;
      default = "enp4s0";
    };
  };

  config = mkIf cfg.enable {
    # https://technicalsourcery.net/posts/nixos-in-libvirt/
    boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.allowedBridges =
      [ "${cfg.libvert.bridgeInterface}" ];

    networking.interfaces."${cfg.libvert.bridgeInterface}".useDHCP = true;

    networking.bridges = {
      "${cfg.libvert.bridgeInterface}" = {
        interfaces = [ "${cfg.libvert.ethInterface}" ];
      };
    };

    environment.systemPackages = with pkgs; [ virt-manager kvm ];
  };
}
