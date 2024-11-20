{ config, pkgs, ... }:

with pkgs;

{
  personal.homebrew.enable = true;
  personal.skhd.enable = true;
  personal.yabai.enable = true;
  personal.sketchybar.enable = false;
  personal.emacs.enable = false;

  personal.one.enable = true;

  # to fix issue with validating manuals
  # https://github.com/NixOS/nixpkgs/issues/196651
  documentation.enable = false;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    tarball-ttl = 86400;
    warn-dirty = false;
    keep-derivations = true;
    keep-outputs = true;
    build-users-group = "nixbld";
    system = "aarch64-darwin";
    extra-platforms = [ "x86_64-darwin" "aarch64-linux" ];
    trusted-users = [ "pablo" "pablo.dealbera.ctr" "@admin" ];
  };

  fonts = {
    packages = [
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };

  users.users."pablo.dealbera.ctr" = {
    name = "pablo.dealbera.ctr";
    home = "/Users/pablo.dealbera.ctr";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    neovim
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.zsh.loginShellInit = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';
  programs.zsh.promptInit = "";

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults.dock = {
    autohide = true;
    autohide-delay = 9999999.0;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
