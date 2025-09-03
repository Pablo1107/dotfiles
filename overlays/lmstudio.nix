self: pkgs:

with pkgs;

{
  lmstudio = pkgs.lmstudio.override ({
    url = "https://installers.lmstudio.ai/linux/x64/0.3.24-3/LM-Studio-0.3.24-3-x64.AppImage";
    hash = "sha256-atTnmjtZ0j5tuIbnpnXBrOZFRgmqnFHzufb+IL7llfk=";
  });
}
