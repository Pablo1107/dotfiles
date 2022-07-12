{ config, pkgs, ... }:

with pkgs;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # personal modules
  personal.fzf.enable = true;
  personal.git.enable = true;
  personal.nix.enable = true;
  personal.ssh.enable = true;
  personal.python.enable = false;
  personal.vifm.enable = true;
  personal.tmux.enable = true;
  personal.shell.enable = true;

  home.packages = [
    jq
    man-pages
    element-desktop

    hledger
    tealdeer
    ffmpeg-full

    # awscli2
    # aws-sam-cli

    # Node
    # (yarn.override { nodejs = nodejs-12_x; })
    yarn
    # (yarn.override { nodejs = nodejs-12_x; })
    nodejs
    # nodejs-14_x
    deno
    efm-langserver

    # AWS
    git-remote-codecommit

    # Databases

    # LSP
    rnix-lsp
    nodePackages.typescript-language-server

    # Rust
    # rustup

    docker-compose
    tesseract
    pandoc
    # mongodb-compass

    # clang

    hicolor-icon-theme
  ];

  programs = {
    command-not-found.enable = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
