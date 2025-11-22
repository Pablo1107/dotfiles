{ config, pkgs, myLib, ... }:

with pkgs;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # personal modules
  personal.emacs.enable = true;
  personal.fzf.enable = true;
  personal.git.enable = true;
  personal.gtk.enable = true;
  personal.htop.enable = true;
  personal.nix.enable = true;
  # personal.python.enable = true;
  personal.ssh.enable = true;
  # personal.syncthing.enable = true;
  personal.xdg.enable = true;
  personal.tmux.enable = true;
  personal.firefox.enable = false;
  personal.rofi.enable = true;
  personal.shell.enable = true;
  # personal.shell.envVariables = {
  #   _JAVA_AWT_WM_NONREPARENTING = "1";
  #
  #   # Needed for Trash, SFTP in Nautilus, etc
  #   # https://github.com/NixOS/nixpkgs/issues/29137#issuecomment-354229533
  #   GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
  # };
  # programs.zsh.loginExtra = ''
  #   source /etc/profile.d/nix-daemon.sh
  # '';
  personal.vifm.enable = true;
  personal.sway.enable = false;
  personal.nvim.enable = true;
  personal.npm.enable = true;
  personal.ai.enable = true;
  personal.latex.enable = true;
  personal.gui.enable = true;
  personal.alacritty.enable = true;
  personal.daw.enable = true;
  personal.spicetify.enable = true;
  personal.niri.enable = true;
  personal.flatpak.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "pablo";
    homeDirectory = "/home/pablo";
  };

  home.packages = [
  ];

  # nix
  caches.cachix = [
    { name = "nix-community"; sha256 = "0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x"; }
  ];


  # VR runtimes
  xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";

  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
  {
    "config" :
    [
      "${config.xdg.dataHome}/Steam/config"
    ],
    "external_drivers" : null,
    "jsonid" : "vrpathreg",
    "log" :
    [
      "${config.xdg.dataHome}/Steam/logs"
    ],
    "runtime" :
    [
      "${pkgs.opencomposite}/lib/opencomposite"
    ],
    "version" : 1
  }
'';

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}
