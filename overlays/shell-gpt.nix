self: pkgs:
{
  shell-gpt = pkgs.shell-gpt.overridePythonAttrs (oldAttrs: {
    propagatedBuildInputs = with pkgs.python3.pkgs; oldAttrs.propagatedBuildInputs ++ [
      litellm
    ];
  });
}

