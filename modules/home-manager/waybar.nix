{ config, options, lib, myLib, pkgs, ... }:

with lib;

let
  cfg = config.personal.waybar;
in
{
  options.personal.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar
      (pkgs.writeScriptBin "hm-updates" ''
        #!/usr/bin/env sh
        cd /tmp

        DOTFILES_PATH=~/dotfiles
        GENERATION_PATH=$(home-manager generations | head -n 1 | awk '{print $NF}')

        cp "$DOTFILES_PATH"/flake.lock "$DOTFILES_PATH"/flake.lock.bak
        nix flake update "$DOTFILES_PATH" >/dev/null 2>&1

        home-manager build --flake "$DOTFILES_PATH" >/dev/null 2>&1

        mv "$DOTFILES_PATH"/flake.lock.bak "$DOTFILES_PATH"/flake.lock

        diff="$(nvd diff $GENERATION_PATH /tmp/result | sed '/^\[.\.\]/d' | sed 's/[<>]//g')"

        rm /tmp/result

        packages_updated=$(echo "$diff" | awk '/Version changes:/{flag=1;next}/Added packages:/{flag=0}flag' | wc -l)
        packages_added=$(echo "$diff" | awk '/Added packages:/{flag=1;next}/Removed packages:/{flag=0}flag' | wc -l)
        packages_removed=$(echo "$diff" | awk '/Removed packages:/{flag=1;next}/Closure size:/{flag=0}flag' | wc -l)

        # format json
        # { "text": " 0  0  0", "tooltip": "$diff" }

        diff=$(echo "$diff" | tail -n +3 | awk 1 ORS='\\n')

        if [ $packages_updated -eq 0 ] && [ $packages_added -eq 0 ] && [ $packages_removed -eq 0 ]; then
          echo -n "{\"text\": \"System up to date\", \"tooltip\": \"$diff\"}"
          exit 0
        fi

        echo -n "{\"text\": \""

        if [ $packages_updated -gt 0 ]; then
          echo -n " $packages_updated"
        fi

        if [ $packages_added -gt 0 ]; then
          echo -n "  $packages_added"
        fi

        if [ $packages_removed -gt 0 ]; then
          echo -n "  $packages_removed"
        fi

        echo "\", \"tooltip\": \"$diff\"}"
      '')
    ];

    home.persistence."${config.home.homeDirectory}/dotfiles/config" = {
      removePrefixDirectory = true;
      allowOther = true;
      files = [
        "waybar/.config/waybar/config"
        "waybar/.config/waybar/style.css"
        "waybar/.config/waybar/waybar.sh"
        "waybar/.config/waybar/waybar-wttr.py"
      ];
    };
  };
}
