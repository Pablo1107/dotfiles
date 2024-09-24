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
    personal.shell.envVariables = {
      # to search pip installed packages
      PYTHONPATH = "$HOME/.local/lib/python3.10/site-packages/";
    };

    home.packages = with pkgs; [
      python3.pkgs.pip
      (
        python3.withPackages (
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
            # pandas-datareader
            requests-cache
            plotly
            svgwrite
            graphviz
            simplejson
            six
          ]
        )
      )
    ];
  };
}
