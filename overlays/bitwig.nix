self: pkgs:

with pkgs;

{
  bitwig-studio5-unwrapped = pkgs.bitwig-studio5-unwrapped.overrideAttrs (
    oldAttrs: rec {
      version = "5.0.4";
      src = pkgs.fetchurl {
        url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
        sha256 = "sha256-IkhUkKO+Ay1WceZNekII6aHLOmgcgGfx0hGo5ldFE5Y=";
      };
      buildInputs = with xorg; oldAttrs.buildInputs ++ [ libXrandr libXext dbus.lib ];
      postFixup = ''
        # patchelf fails to set rpath on BitwigStudioEngine, so we use
        # the LD_LIBRARY_PATH way

        find $out -type f -executable \
          -not -name '*.so.*' \
          -not -name '*.so' \
          -not -name '*.jar' \
          -not -name 'jspawnhelper' \
          -not -path '*/resources/*' | \
        while IFS= read -r f ; do
          patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $f
          # make xdg-open overrideable at runtime
          wrapProgram $f \
            "''${gappsWrapperArgs[@]}" \
            --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}" \
            --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
            --suffix LD_LIBRARY_PATH : "${lib.strings.makeLibraryPath buildInputs}"
        done

        find $out -type f -executable -name 'jspawnhelper' | \
        while IFS= read -r f ; do
          patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $f
        done
      '';
      installPhase = oldAttrs.installPhase + ''
        cp -r "${./bitwig.jar}" $out/libexec/bin/bitwig.jar
      '';
    }
  );
}
