self: pkgs:
{
  local-ai = pkgs.stdenv.mkDerivation rec {
    name = "local-ai";
    version = "1.23.1";
    src = pkgs.fetchurl {
      url = "https://github.com/go-skynet/LocalAI/releases/download/v${version}/local-ai-avx2-Linux-x86_64";
      sha256 = "1z6w4izxanqpq9nhbrxpkdcxacphzmvznah2w0g98pmwgkcxwqg1";
    };
    phases = ["installPhase" "patchPhase"];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/local-ai
      chmod +x $out/bin/local-ai

      mkdir -p $out/lib/systemd/user
      cat <<EOT > $out/lib/systemd/user/local-ai.service
      [Unit]
      Description=Local AI Service

      [Service]
      ExecStart=$out/bin/local-ai
      WorkingDirectory=$out/share/local-ai

      [Install]
      WantedBy=default.target
      EOT
    '';
  };
}

