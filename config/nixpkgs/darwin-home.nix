{ config, pkgs, lib, ... }:

with pkgs;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # personal modules
  personal.fzf.enable = true;
  personal.git.enable = true;
  personal.nix.enable = true;
  personal.ssh.enable = true;
  personal.python.enable = true;
  personal.vifm.enable = true;
  personal.tmux.enable = true;
  personal.shell.enable = true;
  personal.npm.enable = true;
  personal.nvim.enable = true;
  personal.latex.enable = true;
  personal.emacs.enable = true;

  # to fix Application not present in Spotlight
  # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1446696577
  disabledModules = [ "targets/darwin/linkapps.nix" ]; # to use my aliasing instead
  home.activation.aliasApplications =
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
      (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        app_folder="Home Manager Apps"
        app_path="$(echo ~/Applications)/$app_folder"
        tmp_path="$(mktemp -dt "$app_folder.XXXXXXXXXX")" || exit 1
        # NB: aliasing ".../home-path/Applications" to
        #    "~/Applications/Home Manager Apps" doesn't work (presumably
        #     because the individual apps are symlinked in that directory, not
        #     aliased). So this makes "Home Manager Apps" a normal directory
        #     and then aliases each application into there directly from its
        #     location in the nix store.
        for app in \
          $(find "$newGenPath/home-path/Applications" -type l -exec \
            readlink -f {} \;)
        do
          $DRY_RUN_CMD /usr/bin/osascript \
            -e "tell app \"Finder\"" \
            -e "make new alias file at POSIX file \"$tmp_path\" \
                                    to POSIX file \"$app\"" \
            -e "set name of result to \"$(basename $app)\"" \
            -e "end tell"
        done
        # TODO: Wish this was atomic, but it’s only tossing symlinks
        $DRY_RUN_CMD [ -e "$app_path" ] && rm -r "$app_path"
        $DRY_RUN_CMD mv "$tmp_path" "$app_path"
      '');


  # to fix error with validating manuals
  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = false;

  home.packages = [
    jq
    man-pages
    element-desktop

    # hledger
    tealdeer
    ffmpeg-full

    # awscli2
    # aws-sam-cli

    # Node
    # (yarn.override { nodejs = nodejs-12_x; })
    yarn
    # (yarn.override { nodejs = nodejs-12_x; })
    nodejs-16_x

    # AWS
    git-remote-codecommit
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
