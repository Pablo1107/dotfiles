self: pkgs:

with pkgs;

{
  hostapd-210-lar-patch = hostapd.overrideAttrs (oldAttrs: rec {
    patches = [
      (fetchpatch { url = "https://tildearrow.org/storage/hostapd-2.10-lar.patch"; hash = "sha256-USiHBZH5QcUJfZSxGoFwUefq3ARc4S/KliwUm8SqvoI="; })
    ];
  });
}
