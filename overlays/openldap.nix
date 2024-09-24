self: pkgs:

with pkgs;

{
  openldap24 = openldap.overrideAttrs (oldAttrs: {
    postInstall = oldAttrs.postInstall + ''
      ln $out/lib/libldap.so.2.0.200 $out/lib/libldap-2.4.so.2
    '';
  });
}
