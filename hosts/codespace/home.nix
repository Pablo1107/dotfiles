{ config, pkgs, lib, ... }:

with pkgs;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # personal modules
  personal.dotfiles.path = "/workspaces/.codespaces/.persistedshare/dotfiles/config";

  personal.fzf.enable = true;
  personal.git.enable = true;
  personal.nix.enable = true;
  personal.vifm.enable = true;
  personal.tmux.enable = true;
  personal.shell.enable = true;
  personal.nvim.enable = true;

  home.packages = [ ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";
}
