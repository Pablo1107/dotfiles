self: pkgs:
{
  # based on https://github.com/peel/dotfiles/blob/7c4d9a343b02387bdaa429b6b9e903c85a729a6f/overlays/00-basic-pkgs.nix#L7
  yabai = pkgs.stdenvNoCC.mkDerivation rec {
    name = "yabai";
    version = "6.0.15";
    src = pkgs.fetchurl {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "sha256-8+jAdwF7Yganvv1NsbtMIBWv0rh9JmHuwLWmwiFmDu4=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -ar ./* $out
      chmod +x $out/bin/yabai
    '';
  };
}

