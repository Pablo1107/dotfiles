{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.python;
in
{
  options.personal.python = {
    enable = mkEnableOption "python";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python.pkgs.pip
      (
        python310.withPackages (
          ps: with ps; [
            tkinter
            setuptools
            wheel
            pynvim
            requests
            jinja2
            ply
            pyaml
            numpy
            sympy
            pygments
            matplotlib
            pandas-datareader
            requests-cache
            plotly
            svgwrite
            graphviz
            simplejson
          ]
        )
      )
    ];
  };
}
