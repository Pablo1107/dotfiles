{ config, pkgs, ... }:

with pkgs;

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    build-users-group = nixbld
    system = aarch64-darwin
    extra-platforms = x86_64-darwin aarch64-darwin
    warn-dirty = false
  '';

  fonts.enableFontDir = true;
  fonts.fonts = [
    hack-font
  ];

  users.users.pablo = {
    name = "pablo";
    home = "/Users/pablo";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    neovim
  ];

  # Homebrew
  system.activationScripts.homebrew.text = ''
    # Check to see if Homebrew is installed, and install it if it is not
    if [ -f "${config.homebrew.brewPrefix}/brew" ]; then
      echo "Homebrew is installed, skipping..." >&2
    else
      echo "Installing Homebrew Now" >&2
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

  homebrew = {
    enable = true;
    cleanup = "uninstall";
    taps = [
      "homebrew/cask"
    ];
    brews = [
      "pkg-config"
      "pixman"
      "cairo"
      "pango"
    ];
    casks = [
      "firefox"
      "zoom"
      "google-chrome"
      "chromium"
      "insomnia"
      "docker"
      "spotify"
      "alacritty"
      "telegram"
      "whatsapp"
    ];
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.zsh.loginShellInit = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';
  programs.zsh.promptInit = "";
  # programs.fish.enable = true;

  services.khd = {
    enable = true;
    khdConfig = ''
      cmd - return : open -na /Applications/Alacritty.app;\
    '';
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
