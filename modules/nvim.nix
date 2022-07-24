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
      neovim
      efm-langserver
      rnix-lsp
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
      sumneko-lua-language-server
      clang-tools
      nodePackages.prettier_d_slim
    ];

    home.persistence."${config.home.homeDirectory}/dotfiles/config" = {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "nvim/.config/nvim/ftplugin"
        "nvim/.config/nvim/lua"
        "nvim/.config/nvim/init.lua"
      ];
    };
  };
}
