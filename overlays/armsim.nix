self: pkgs:

with pkgs;

{
  armsim = stdenv.mkDerivation rec {
    pname = "armsim";
    version = "2.1";

    src = fetchurl {
      url = "https://webhome.cs.uvic.ca/~nigelh/ARMSim-V2.1/Linux/ARMSimLinuxFiles.zip";
      sha256 = "sha256-zE1ZguYRoAace6Hme3PdqG6XyDeC9PCuwf9gxMtWMlk=";
    };

    phases = [ "unpackPhase" "installPhase" ];

    sourceRoot = ".";

    nativeBuildInputs = [ unzip ];

    buildInputs = [ mono gcc ];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/ARMSim
      cp -r ./ $out/ARMSim
      cat > $out/bin/ARMSim <<EOF
#!/bin/sh
${mono}/bin/mono --debug $out/ARMSim/ARMSim.exe
EOF
      chmod +x $out/bin/ARMSim

      ln -s ${gcc-arm-embedded}/bin/arm-none-eabi-as $out/ARMSim/arm-none-eabi-as
    '';

    meta = with lib; {
      description = "ARMSim# - ARM Simulator";
      homepage = "https://webhome.cs.uvic.ca/~nigelh/ARMSim-V2.1/Linux/index.html";
      platforms = platforms.linux;
    };
  };
}
