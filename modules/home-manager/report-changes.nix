{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.reportChanges;
in
{
  options.personal.reportChanges = {
    enable = mkEnableOption "reportChanges";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nvd
    ];
    home.activation.reportChanges = lib.hm.dag.entryAnywhere ''
      ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
    '';
  };
}

