{ config, pkgs, ... }:

with pkgs;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # personal modules
  personal.fzf.enable = true;
  personal.git.enable = true;
  personal.htop.enable = true;
  personal.nix.enable = true;
  personal.ssh.enable = true;
  personal.tmux.enable = true;
  personal.vifm.enable = true;
  personal.nvim.enable = true;
  personal.shell.enable = true;
  personal.transmission.enable = true;

  home = {
    username = "deck";
    homeDirectory = "/home/deck";

    packages = [ ];

    stateVersion = "21.05";
  };
}
