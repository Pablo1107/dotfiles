self: pkgs:

with pkgs;

{
  customNodePackages = pkgs.callPackage ./node-packages {};
}
