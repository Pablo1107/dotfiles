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
      settings = {
        user = {
          name = "Pablo Andres Dealbera";
          email = "dealberapablo07@gmail.com";
        };
        alias = {
          fza = "!git ls-files -m -o --exclude-standard | fzf --print0 -m | xargs -0 -t -o git add";
          llm-commit = "!git commit -e -m \"$(git diff --staged $(git diff --staged --stat | awk '/\\|/ { if ($3 < 15) print $1 }') | llm -m $\{1:-gemma3:27b\} -s \"$(cat ~/.config/llm/git-commit-system-prompt.txt)\")\"";
        };
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

    programs.zsh.siteFunctions = {
      "git-checkout-worktree" = ''
        branch="$1"
        if [ -z "$branch" ]; then
          echo "Usage: git-checkout-worktree <branch>"
          exit 1
        fi

        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "Not inside a git repository."
          exit 1
        fi

        repo="$(basename "$(pwd)")"
        target="../$repo-$branch"

        echo "→ Preparing worktree for '$branch' at '$target'"

        # Create local branch if it doesn't exist but remote does
        if ! git show-ref --verify --quiet "refs/heads/$branch"; then
          if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
            echo "→ Creating local branch from origin/$branch"
            git branch "$branch" "origin/$branch"
          else
            echo "Error: branch '$branch' not found locally or remotely"
            exit 1
          fi
        fi

        git worktree add "$target" "$branch" || exit 1

        cd "$target" || exit 1
        echo "→ Now in $target"
      '';

      "git-remove-worktree" = ''
        branch="$1"
        if [ -z "$branch" ]; then
          echo "Usage: git-remove-other <branch>"
          exit 1
        fi

        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "Not inside a git repository."
          exit 1
        fi

        repo="$(basename "$(pwd)")"
        target="../$repo-$branch"

        echo "→ Removing worktree for branch '$branch' at '$target'"

        if [ ! -d "$target" ]; then
          echo "Worktree directory not found: $target"
          exit 1
        fi

        git worktree remove "$target" --force || return 1
        echo "→ Worktree removed successfully."
      '';
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
