{ lib
, appimageTools
, fetchurl
}:

let
  pname = "more-of-dots";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/aexer0e/more-of-dots/releases/download/v${version}/More.of.Dots_${version}_amd64.AppImage";
    hash = "sha256-6UGS5zD9s8XRkVgrm9v6QqLgxP3aCidox1+DfdwK1CY=";
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
