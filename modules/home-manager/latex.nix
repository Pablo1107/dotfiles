{ config, options, lib, myLib, pkgs-stable, ... }:

with lib;

let
  cfg = config.personal.latex;

  # from https://nixos.wiki/wiki/TexLive
  tex = (pkgs-stable.texlive.combine {
    inherit (pkgs-stable.texlive) scheme-small
      wrapfig amsmath ulem hyperref capt-of
      newverbs tikzpagenodes ifoddpage
      dvipng minted fvextra catchfile
      xstring framed a4wide svg trimspaces
      transparent tocbibind microtype stix
      geometry
      ;
  });
in
{
  options.personal.latex = {
    enable = mkEnableOption "latex";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs-stable; [
      tex
      pandoc
    ];
  };
}
