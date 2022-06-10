{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.syncthing;
in
{
  options.personal.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      history.extended = true;
      history.size = 10000000;
      shellAliases = shellAliases;
      autocd = true;

      initExtra = keyBindings + shellFunctions + ''
        fpath+=${pure-prompt}/share/zsh/site-functions
        autoload -U promptinit;
        promptinit
          prompt pure
 
          eval "$(${pkgs.z-lua}/bin/z --init zsh)"
      '';

      loginExtra = ''
        setopt extendedglob
        setopt appendhistory
        setopt autocd

        source /etc/profile.d/nix-daemon.sh
      '';

      profileExtra = ''
        . /etc/profile
      '';

      # sessionVariables = sessionVariables;
    };

    bash = {
      enable = true;
      # sessionVariables = sessionVariables;
      shellAliases = shellAliases;
    };
  };
}
