{ config, pkgs, myLib, ... }:

with pkgs;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # personal modules
  personal.fzf.enable = true;
  # personal.git.enable = true;
  personal.htop.enable = true;
  personal.xdg.enable = true;
  personal.tmux.enable = true;
  personal.shell.enable = true;
  personal.vifm.enable = true;
  personal.nvim.enable = true;

  home = {
    username = "root";
    homeDirectory = "/root";
  };

  home.packages = [ ];

  home.stateVersion = "23.11";
}
