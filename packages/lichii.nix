{ appimageTools
, fetchurl
, makeWrapper
, symlinkJoin
}:

let
  pname = "lichii";

  # zortos293's Eglantine fork, which the app now brands as Lichii (the repo was
  # renamed from Eglantine to Lichii too). Prebuilt nx2 AppImage (PGO build) from
  # the newest `build-NN` pre-release, which nvfetcher's release tracker skips:
  # bump `version` and `hash` by hand (or run update.sh) from the latest release
  # at https://github.com/zortos293/Lichii/releases (pick the newest build-NN).
  version = "build-228";

  src = fetchurl {
    url = "https://github.com/zortos293/Lichii/releases/download/${version}/lichii-linux-x86_64-pgo.AppImage";
    hash = "sha256-AGEDbmhrwFN3tF3fvGmvcfwt9KgBfD/Srw1mThXOcDo=";
  };

  # The desktop entry (Exec=lichii already) and icon live inside the AppImage.
  contents = appimageTools.extract { inherit pname version src; };

  # wrapType2 runs the AppImage in an FHS sandbox; its binary is $out/bin/lichii.
  # vulkan-loader lets the bundled app reach the NixOS GPU drivers under
  # /run/opengl-driver so Vulkan (the emulator's main renderer) works. libgpg-error
  # is linked by a bundled lib but, unlike libgcrypt, is absent from appimageTools'
  # default FHS on this nixpkgs, so the AppImage fails to load without it.
  fhs = appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: [ pkgs.vulkan-loader pkgs.libgpg-error ];
  };
in
symlinkJoin {
  name = "${pname}-${version}";
  paths = [ fhs ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    # Offload to the AMD eGPU (Navi 44, RX 9060 XT, 1002:7590) for Vulkan, with
    # DRI_PRIME for any GL path. --set-default so an unplugged eGPU falls back to
    # the iGPU and a manual env still wins.
    #
    # The AppImage bundles only the xcb Qt platform plugin (no qtwayland), so under
    # a Wayland session that exports QT_QPA_PLATFORM=wayland it finds no usable
    # plugin and aborts. Force xcb so it runs through XWayland (xwayland-satellite).
    wrapProgram $out/bin/${pname} \
      --set QT_QPA_PLATFORM xcb \
      --set-default MESA_VK_DEVICE_SELECT 1002:7590 \
      --set-default DRI_PRIME 1

    install -Dm444 ${contents}/usr/share/applications/io.github.zortos293.lichii.desktop \
      $out/share/applications/lichii.desktop
    install -Dm444 ${contents}/usr/share/icons/hicolor/256x256/apps/io.github.zortos293.lichii.png \
      $out/share/icons/hicolor/256x256/apps/io.github.zortos293.lichii.png
  '';

  meta = {
    description = "Experimental Nintendo Switch 2 emulator (zortos293's Eglantine fork, branded Lichii; upstream AppImage)";
    homepage = "https://github.com/zortos293/Lichii";
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
