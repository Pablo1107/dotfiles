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
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        lazy-nvim
      ];
      extraPackages = (with pkgs; [
        efm-langserver
        nixd
        nil
        nixpkgs-fmt
        sumneko-lua-language-server
        gcc
        rust-analyzer
        clang-tools
        nixfmt-classic # nix formatter
        nixpkgs-fmt # nix formatter
        alejandra # nix formatter
      ]) ++ (with pkgs.nodePackages; [
        nodejs
        typescript
        typescript-language-server
        vim-language-server
        prettier_d_slim
        vscode-langservers-extracted
        pkgs.customNodePackages."@vtsls/language-server"
      ]);
    };

    # stolen from https://discourse.nixos.org/t/conflicts-between-treesitter-withallgrammars-and-builtin-neovim-parsers-lua-c/33536/3
    xdg.configFile."nvim/parser".source = "${pkgs.symlinkJoin {
      name = "treesitter-parsers";
      paths = (pkgs.vimPlugins.nvim-treesitter.withAllGrammars).dependencies;
    }}/parser";

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
