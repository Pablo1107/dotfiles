self: pkgs:
{
  local-shell-gpt = pkgs.shell_gpt.overrideAttrs (oldAttrs: {
    patches = [ ./local-shell-gpt.patch ];
  });
}

