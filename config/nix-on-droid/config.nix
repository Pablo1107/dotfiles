{ pkgs, ... }:

with pkgs;

{
  environment.packages = [
    neovim
    git
    openssh
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    ncurses
    neofetch
  ];

  user = {
    #username = "pablo";
    shell = "${pkgs.zsh}/bin/zsh";
  };

  system.stateVersion = "21.11";
}
