self: pkgs:
{
  vscode-codicons = pkgs.stdenv.mkDerivation rec {
    name = "vscode-codicons";
    version = "0.0.35";
    src = pkgs.fetchFromGitHub {
      owner = "microsoft";
      repo = "vscode-codicons";
      rev = "${version}";
      sha256 = "sha256-d0UuB/fNXTonaLWdCa1ZlZxnwZuI8+spBk8bFwYSuK4=";
    };
    phases = [ "installPhase" "patchPhase" ];
    installPhase = ''
      mkdir -p $out/share/fonts/vscode-codicons
      cp $src/dist/codicon.ttf $out/share/fonts/vscode-codicons
    '';
  };
}

