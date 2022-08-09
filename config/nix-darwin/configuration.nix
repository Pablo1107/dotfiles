{ config, pkgs, ... }:

with pkgs;

{
  personal.homebrew.enable = true;
  personal.skhd.enable = true;
  personal.yabai.enable = true;
  personal.sketchybar.enable = false;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    build-users-group = nixbld
    system = aarch64-darwin
    extra-platforms = x86_64-darwin aarch64-darwin
    warn-dirty = false
  '';

  fonts = {
    fontDir.enable = true;
    fonts = [
      hack-font
    ];
  };

  users.users.pablo = {
    name = "pablo";
    home = "/Users/pablo";
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
