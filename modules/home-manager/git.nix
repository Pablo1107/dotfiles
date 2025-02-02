{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.git;
in
{
  options.personal.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Pablo Andres Dealbera";
      userEmail = "dealberapablo07@gmail.com";
      aliases = {
        fza = "!git ls-files -m -o --exclude-standard | fzf --print0 -m | xargs -0 -t -o git add";
        llm-commit = "!git commit -e -m \"$(git diff --staged | llm -m $\{1:-gemma2:27b\} -s \"$(cat ~/.config/llm/git-commit-system-prompt.txt)\")\"";
      };
      extraConfig = {
        push.followTags = true; # always push tags when "git push"
        credential = {
          helper = "store";
        };
        # pager.show = "nvim -R -c '%sm/\\e.\\{-}m//ge' +1 -";
        diff.tool = "nvimdiff";
        difftool.nvimdiff.cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
        # difftool.prompt = false;
        #url."ssh://git@github.com/".insteadOf = "https://github.com/";
        core.excludesfile = "~/.config/git/gitignore";
      };
      lfs.enable = true;
    };

    home.persistence."${config.home.homeDirectory}/dotfiles/config" = {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "llm/.config/llm/git-commit-system-prompt.txt"
      ];
    };
  };
}
