{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.latex;

  # from https://nixos.wiki/wiki/TexLive
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-small
      wrapfig amsmath ulem hyperref capt-of
      newverbs tikzpagenodes ifoddpage
    ;
  });
in
{
  options.personal.latex = {
    enable = mkEnableOption "latex";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tex
    ];
  };
}
