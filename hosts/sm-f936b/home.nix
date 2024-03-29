{ config, pkgs, lib, ... }:

{
  personal.fzf.enable = true;
  personal.git.enable = true;
  personal.nix.enable = true;
  personal.ssh = {
    enable = true;
    withAuthorizationKeys = true;
  };
  personal.python.enable = false;
  personal.vifm.enable = true;
  personal.tmux.enable = true;
  personal.shell.enable = true;
  personal.shell.envVariables =
    let dnshack = pkgs.callPackage (builtins.fetchTarball "https://github.com/ettom/dnshack/tarball/master") { };
    in
    {
      LEDGER_FILE = lib.mkForce "$HOME/ledger/2023.journal";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      DNSHACK_RESOLVER_CMD = "${dnshack}/bin/dnshackresolver";
      LD_PRELOAD = "${dnshack}/lib/libdnshackbridge.so";
    };
  personal.nvim.enable = true;
  personal.npm.enable = true;
  # personal.ai.enable = true;
  personal.emacs.enable = true;

  home.shellAliases = {
    ping = "/android/system/bin/linker64 /android/system/bin/ping";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    #username = "pablo";
    #homeDirectory = "/data/data/com.termux.nix/files/home/";
  };

  home.packages = with pkgs; [
    hledger
    gawk
    android-tools
  ];

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
