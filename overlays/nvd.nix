self: pkgs:
{
  nvd = pkgs.nvd.overrideAttrs (oldAttrs: {
    patches = [ ./nvd.patch ];
  });
}
