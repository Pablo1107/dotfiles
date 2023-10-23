{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.nvim;
in
{
  options.personal.nvim = {
    enable = mkEnableOption "nvim";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      efm-langserver
      rnix-lsp
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
      sumneko-lua-language-server
      gcc
      nodePackages.prettier_d_slim
      nodePackages.vscode-langservers-extracted
    ];

    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        lazy-nvim
      ];
    };

    home.persistence."${config.home.homeDirectory}/dotfiles/config" = {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "nvim/.config/nvim/ftplugin"
        "nvim/.config/nvim/lua"
        "nvim/.config/nvim/init.lua"
        "nvim/.config/nvim/.ignore"
      ];
    };

    home.activation = {
      nvimTSUpdate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATH="${config.home.path}/bin:$PATH" ${pkgs.neovim}/bin/nvim --headless +TSUpdateSync +qa
        printf "\n\n"
      '';
    };
  };
}
