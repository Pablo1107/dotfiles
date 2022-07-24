self: pkgs:
{
  # based on https://github.com/peel/dotfiles/blob/7c4d9a343b02387bdaa429b6b9e903c85a729a6f/overlays/00-basic-pkgs.nix#L7
  yabai = pkgs.stdenvNoCC.mkDerivation {
    name = "yabai";
    version = "4.0.1";
    src = pkgs.fetchurl {
      url = "https://github.com/koekeishiya/yabai/releases/download/v4.0.1/yabai-v4.0.1.tar.gz";
      sha256 = "sha256-UFtPBftcBytzvrELOjE4vPCKc3CCaA4bpqusok5sUMU=";
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

