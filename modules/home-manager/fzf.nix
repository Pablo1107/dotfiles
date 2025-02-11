{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.fzf;
in
{
  options.personal.fzf = {
    enable = mkEnableOption "fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
      # fileWidgetCommand = "$FZF_DEFAULT_COMMAND";
      defaultOptions = [
        "--bind tab:toggle-out,shift-tab:toggle-in"
        "--bind alt-j:down,alt-k:up,ctrl-j:preview-down,ctrl-k:preview-up"
        "--color=dark"
        "--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f"
        "--color=info:#7aa6da,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
      ];
    };
  };
}

