self: pkgs:

with pkgs;

{
  shortix = stdenv.mkDerivation rec {
    name = "shortix";
    version = "0.6.0";
    src = fetchFromGitHub {
      owner = "Jannomag";
      repo = "shortix";
      rev = "v${version}";
      sha256 = "sha256-7piAR+92Sj74GuG6DqqgG00BXAIfUmil8S2FstS/unQ=";
    };
    phases = [ "installPhase" ];
    buildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src/shortix.sh $out/bin/shortix
      substituteInPlace $out/bin/shortix \
        --replace-fail 'PROTONTRICKS_NATIVE="protontricks"' 'PROTONTRICKS_NATIVE=${protontricks}/bin/protontricks'
      chmod +x $out/bin/shortix
    '';

    meta = with lib; {
      description = "Shortix";
      license = licenses.gpl3Only;
      homepage = "https://github.com/Jannomag/shortix";
      platforms = platforms.linux;
      maintainers = with maintainers; [ ];
    };
  };
}

