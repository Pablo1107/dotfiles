self: pkgs:

with pkgs;

{
  abpl =
    let
      rarFile = fetchurl {
        url = "https://alt1.plugins4free.com/get_plug/ABPL_2_3_1_Complete_Installer.exe";
        sha256 = "sha256-bAFV9veGlrfgd6M0e1iEYVF6izXy3Fkm9zXWdgVHmXc=";
      };
      bin = wrapWine {
        name = "abpl";
        executable = "$WINEPREFIX/drive_c/ABPL_2_3_1_Complete_Installer/ABPL_2_3_1_Complete_Installer.exe";
        is64bits = true;
        firstrunScript = ''
          pushd "$WINEPREFIX/drive_c"
            ${unrar}/bin/unrar x ${rarFile}
          popd
        '';
        tricks = [ ];
      };
    in
    bin;
}
