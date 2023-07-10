self: pkgs:
{
  local-ai = pkgs.stdenv.mkDerivation {
    name = "local-ai";
    src = pkgs.fetchurl {
      url = "https://github.com/go-skynet/LocalAI/releases/download/v1.20.1/local-ai-avx-Linux-x86_64";
      sha256 = "sha256-DZtMwdp4wPNc8kJJpJotDvyyU4p6eRvDV5fEP2GRfSo=";
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

