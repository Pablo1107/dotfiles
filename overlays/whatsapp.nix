self: pkgs:

with pkgs;

{
  whatsapp =
    let
      version = "2.2326.10-full";
      installer = fetchurl {
        url = "https://web.whatsapp.com/desktop/windows/release/x64/WhatsAppSetup.exe";
        sha256 = "sha256-cE7Ti4+M8guPuNE/iFEhRpGTtyJH7OBtTJaFhFimFec=";
      };

      bin = wrapWine {
        is64bits = true;
        name = "whatsapp";
        executable = "$WINEPREFIX/drive_c/lib/net45/WhatsApp.exe";
        firstrunScript = ''
          pushd "$WINEPREFIX/drive_c"
            ${p7zip}/bin/7z x ${installer} -y
            ${p7zip}/bin/7z x WhatsApp-${version}.nupkg -y
          popd
        '';
        tricks = [
          "ie8"
          "dotnet462"
        ];
      };
      # desktop = makeDesktopItem {
      #   name = "Pinball";
      #   desktopName = "Pinbal - Space Cadet";
      #   icon = fetchurl {
      #     url = "https://www.chip.de/ii/1/8/8/0/2/9/2/3/028c4582789e6c07.jpg";
      #     sha256 = "1lwsnsp4hxwqwprjidgmxksaz13ib98w34r6nxkhcip1z0bk1ilz";
      #   };
      #   type = "Application";
      #   exec = "${bin}/bin/pinball";
      # };
    in
    symlinkJoin {
      name = "whatsapp";
      paths = [
        bin
        # desktop
      ];
    };
}
