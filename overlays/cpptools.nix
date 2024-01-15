self: pkgs:
{
  vscode-extensions = pkgs.vscode-extensions // {
    ms-vscode =
      pkgs.vscode-extensions.ms-vscode // {
        cpptools =
          pkgs.vscode-extensions.ms-vscode.cpptools.overrideAttrs (oldAttrs: {
            postPatch = oldAttrs.postPatch + ''
              cp debugAdapters/bin/cppdbg.ad7Engine.json debugAdapters/bin/nvim-dap.ad7Engine.json
            '';
          });
      };
  };
}
