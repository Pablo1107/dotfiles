self: pkgs:

with pkgs;

let
  name = "moises-desktop";
  src = fetchurl {
    url = "https://desktop.moises.ai/";
    curlOptsList = [
      "-H"
      "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:123.0) Gecko/20100101 Firefox/123.0"
    ];
    hash = "sha256-Da7CCwDH6Y83ud9MEXImRl17c/ZzLNfvoiE0sGRsEbg=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in {
  moises-desktop = appimageTools.wrapType2 {
    inherit name src;
    extraPkgs = pkgs: [ ];
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/moises-desktop.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/moises-desktop.desktop \
        --replace 'Exec=AppRun' 'Exec=${name}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };
}
