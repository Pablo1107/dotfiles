{ lib
, appimageTools
, fetchurl
}:

let
  pname = "more-of-dots";
  version = "2.4.1";

  src = fetchurl {
    url = "https://github.com/aexer0e/more-of-dots/releases/download/v${version}/More.of.Dots_${version}_amd64.AppImage";
    hash = "sha256-HMnWPs4pg4F5KDpLvtY+LJ7wf3YoWGzEaSkXApxww6k=";
  };

  contents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    for f in ${contents}/*.desktop; do
      install -Dm644 "$f" "$out/share/applications/${pname}.desktop"
    done
    if [ -d ${contents}/usr/share/icons ]; then
      mkdir -p $out/share
      cp -r ${contents}/usr/share/icons $out/share/
    fi
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-quiet "Exec=AppRun" "Exec=${pname}"
  '';

  meta = with lib; {
    description = "More of Dots";
    homepage = "https://github.com/aexer0e/more-of-dots";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = pname;
  };
}
