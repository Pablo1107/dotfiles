self: pkgs:

with pkgs;

{
  # https://github.com/cenunix/NixLand/blob/8d6bfc12c9a7ac563cf0a6db83f4e066a25ecc5b/core/system/virt/default.nix#L9
  qemu-anti-detection =
    (pkgs.qemu_kvm.override {
      hostCpuOnly = true;
    }).overrideAttrs
      (
        finalAttrs: previousAttrs: {
          # ref: https://github.com/zhaodice/qemu-anti-detection
          patches = (previousAttrs.patches or [ ]) ++ [
            # (pkgs.fetchpatch {
            #   url = "https://raw.githubusercontent.com/zhaodice/qemu-anti-detection/main/qemu-8.2.0.patch";
            #   sha256 = "sha256-RG4lkSWDVbaUb8lXm1ayxvG3yc1cFdMDP1V00DA1YQE=";
            # })
            ./spoof.patch
          ];
          src = pkgs.fetchurl {
            url = "https://download.qemu.org/qemu-${finalAttrs.version}.tar.xz";
            hash = "sha256-73hvI5jLUYRgD2mu9NXWke/URXajz/QSbTjUxv7Id1k=";
          };
          # postFixup =
          #   (previousAttrs.postFixup or "")
          #   + "\n"
          #   + ''
          #     for i in $(find $out/bin -type f -executable); do
          #       mv $i "$i-anti-detection"
          #     done
          #   '';
          version = "10.0.2";
          # pname = "qemu-anti-detection";
        }
      );
}
