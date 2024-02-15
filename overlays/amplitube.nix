self: pkgs:

with pkgs;

{
  amplitube5 =
    let
      wine = pkgs.wineWowPackages.stable;
      # installer = wrapWine {
      #   name = "amplitube5";
      #   executable = "/var/lib/transmission/Downloads/IK Multimedia - AmpliTube v5.7.0/Setup AmpliTube 5 v5.7.0.exe";
      #   is64bits = true;
      #   tricks = [
      #     "mfc42"
      #     "vcrun6sp6"
      #   ];
      # };
      bin = wrapWine {
        name = "amplitube5";
        executable = "$WINEPREFIX/drive_c/Program\ Files/IK\ Multimedia/AmpliTube\ 5/AmpliTube\ 5.exe";
        is64bits = true;
        firstrunScript = ''
          ${wine}/bin/wine64 "$INSTALLER_PATH/Setup AmpliTube 5 v5.7.0.exe"
          ${wine}/bin/wine64 "$INSTALLER_PATH/R2R/IK_Multimedia_Keygen.exe"
        '';
        tricks = [
          "mfc42"
          "vcrun6sp6"
          "corefonts"
        ];
      };
      desktop = makeDesktopItem {
        name = "Amplitube";
        desktopName = "Amplitube";
        icon = fetchurl {
          url = "https://s.cafebazaar.ir/images/icons/com.ikmultimediaus.android.amplitubeua_512x512.png";
          sha256 = "sha256-VXS4X9NBE7/Jk9yI5ZS/XhK72tQKyXMZtHRHs1WvUWA=";
        };
        type = "Application";
        exec = "${bin}/bin/amplitube5";
      };
    in
    symlinkJoin {
      name = "amplitube5";
      paths = [
        bin
        desktop
      ];
    };
}
