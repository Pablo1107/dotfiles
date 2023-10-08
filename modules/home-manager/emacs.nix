{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.emacs;
in
{
  options.personal.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 emacs29-pgtk)
      (lib.mkIf pkgs.stdenv.hostPlatform.isAarch64 emacs29-nox)
      plantuml
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
