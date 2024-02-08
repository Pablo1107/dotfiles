self: pkgs:
{
  local-shell-gpt = pkgs.shell_gpt.overrideAttrs (oldAttrs: rec {
    pname = "shell_gpt";
    version = "1.2.0";
    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-4R4pzUFbI0+o+gi8cRqbrPoTlySebo/FvGerEu7jnes=";
    };
    propagatedBuildInputs = with pkgs.python3.pkgs; oldAttrs.propagatedBuildInputs ++ [
      # instructor missing nixpkgs python dep
      # https://pypi.org/project/instructor/
      openai
    ];
    patches = [ ./local-shell-gpt.patch ];
  });
}

