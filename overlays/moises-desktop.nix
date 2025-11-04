self: pkgs:

with pkgs;

let
  pname = "moises-desktop";
  version = "1.2.5"; # Idk if this is the version I'm using right now...
  src = fetchurl {
    url = "https://desktop.moises.ai/";
    curlOptsList = [
      "-H"
      "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:123.0) Gecko/20100101 Firefox/123.0"
    ];
    hash = "sha256-sGfOFJaXQ3xfLRCG/CtdrVU7XrJdKWekFhbL4oMZjXs=";
  };
  appimageContents = appimageTools.extract { inherit pname src version; };
in {
  moises-desktop = appimageTools.wrapType2 {
    inherit pname src version;
    extraPkgs = pkgs: [ ];
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/moises-desktop.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/moises-desktop.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };
}
