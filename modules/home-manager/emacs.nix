{ config, options, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.personal.emacs;

  copilot = { trivialBuild, dash, s, editorconfig }: trivialBuild {
    pname = "copilot";
    version = "main";
    src = inputs.emacs-copilot;
    buildInputs = [ dash s editorconfig ];
    postPatch = ''
      ${pkgs.perl}/bin/perl -i -p0e "s#\(defconst copilot--base-dir\n  \(file-name-directory\n   \(or load-file-name\n       \(buffer-file-name\)\)\)\n  \"Directory containing this file.\"\)\n#(defconst copilot--base-dir\n  \"${inputs.emacs-copilot.outPath}\"\n  \"Directory containing this file.\")#" ./copilot.el
    '';
  };

  emacs = pkgs.emacsWithPackagesFromUsePackage {
    package = if pkgs.stdenv.hostPlatform.isx86_64 then pkgs.emacs29-pgtk else pkgs.emacs29-nox;
    config = "../../config/emacs/.config/emacs/init.el";

    alwaysEnsure = true;

    # Optionally provide extra packages not in the configuration file.
    extraEmacsPackages = epkgs: [
      (copilot { inherit (epkgs) trivialBuild dash s editorconfig; })
      epkgs.pdf-tools
    ];

    # Optionally override derivations.
    # override = epkgs: epkgs // {
    #   somePackage = epkgs.melpaPackages.somePackage.overrideAttrs (old: {
    #     # Apply fixes here
    #   });
    # };
  };
in
{
  options.personal.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      emacs
      plantuml
      nodejs
    ];

    home.persistence."${config.home.homeDirectory}/dotfiles/config" = {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "emacs/.config/emacs/init.el"
      ];
    };

    xdg.mimeApps = {
      # query mime type from a file like this:
      # xdg-mime query filetype your-file.extension
      # also check out:
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
      defaultApplications = {
        "text/x-tex" = [ "emacs.desktop" ];
      };
    };

    systemd.user.services.emacs = {
      Unit = {
        Description = "Emacs text editor";
        Documentation =
          "info:emacs man:emacs(1) https://gnu.org/software/emacs/";

        # Avoid killing the Emacs session, which may be full of
        # unsaved buffers.
        X-RestartIfChanged = false;
      };

      Service = {
        Type = "notify";

        # We wrap ExecStart in a login shell so Emacs starts with the user's
        # environment, most importantly $PATH and $NIX_PROFILES. It may be
        # worth investigating a more targeted approach for user services to
        # import the user environment.
        ExecStart = ''
          ${pkgs.runtimeShell} -l -c "emacs --fg-daemon";
        '';

        # Emacs will exit with status 15 after having received SIGTERM, which
        # is the default "KillSignal" value systemd uses to stop services.
        SuccessExitStatus = 15;

        Restart = "on-failure";
      };

      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}
