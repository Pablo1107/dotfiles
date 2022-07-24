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
    skhd
    yabai
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
      "homebrew/services"
    ];
    brews = [
      "pkg-config"
      "pixman"
      "cairo"
      "pango"
      "syncthing"
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
      "dbeaver-community"
      "steam"
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

  services.skhd = {
    enable = true;
    skhdConfig = ''
      cmd - return : open -na Alacritty.app
      cmd - h : yabai -m window --focus west
      cmd - l : yabai -m window --focus east
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north

      # swap managed window
      shift + cmd - h : yabai -m window --warp west
      shift + cmd - l : yabai -m window --warp east
      shift + cmd - j : yabai -m window --warp south
      shift + cmd - k : yabai -m window --warp north

      # balance size of windows
      shift + cmd - 0 : yabai -m space --balance

      # fast focus desktop
      # cmd - tab : yabai -m space --focus recent
      cmd - 1 : yabai -m space --focus 1
      cmd - 2 : yabai -m space --focus 2
      cmd - 3 : yabai -m space --focus 3
      cmd - 4 : yabai -m space --focus 4
      cmd - 5 : yabai -m space --focus 5
      cmd - 6 : yabai -m space --focus 6
      cmd - 7 : yabai -m space --focus 7
      cmd - 8 : yabai -m space --focus 8

      shift + cmd - 1 : yabai -m window --space 1
      shift + cmd - 2 : yabai -m window --space 2
      shift + cmd - 3 : yabai -m window --space 3
      shift + cmd - 4 : yabai -m window --space 4
      shift + cmd - 5 : yabai -m window --space 5
      shift + cmd - 6 : yabai -m window --space 6
      shift + cmd - 7 : yabai -m window --space 7
      shift + cmd - 8 : yabai -m window --space 8

      # control window size, modified to be intuitive
      cmd + ctrl - h : yabai -m window --resize left:-20:0;yabai -m window --resize right:-20:0
      cmd + ctrl - l : yabai -m window --resize right:20:0;yabai -m window --resize left:20:0
      cmd + ctrl - j : yabai -m window --resize bottom:0:20;yabai -m window --resize top:0:20
      cmd + ctrl - k : yabai -m window --resize top:0:-20;yabai -m window --resize bottom:0:-20

      # float / unfloat window and center on screen
      cmd - t : yabai -m window --toggle float;\
                yabai -m window --grid 4:4:1:1:2:2

      # close window yabai way, not overriding system default
      cmd + shift - q : yabai -m window --close
    '';
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    config = {
      # layout
      layout = "bsp";
      #auto_balance = "on";
      split_ratio = "0.62";
      # Gaps
      top_padding = "2";
      bottom_padding = "2";
      left_padding = "2";
      right_padding = "2";
      window_gap = "12";
      # shadows and borders
      #window_shadow = "on";
      window_border = "on";
      window_border_width = 1;
      active_window_border_color = "0xff007CA6";
      normal_window_border_color = "0x00ffffff";
      window_opacity = "on";
      window_opacity_duration = "0.1";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.9";
      # mouse
      mouse_modifier = "cmd";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
      mouse_follows_focus = "on";
      focus_follows_mouse = "autoraise";
    };
    extraConfig = ''
      # load script for extended features
      sudo yabai --load-sa
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

      # Do not manage windows with certain titles eg. Copying files or moving to bin
      yabai -m rule --add title="(Copy|Bin|About This Mac|Info)" manage=off

      # Do not manage some apps which are not resizable
      yabai -m rule --add app="^(Calculator|System Preferences|[sS]tats)$" layer=above manage=off
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
