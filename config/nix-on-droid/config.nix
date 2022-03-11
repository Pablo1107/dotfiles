{ pkgs, ... }:

with pkgs;

{
  environment.packages = [
    neovim
    git
    openssh
  ];
  system.stateVersion = "21.11";
}
