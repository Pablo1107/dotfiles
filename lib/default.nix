{ nixpkgs, ... }:

rec {
  getDotfile = ref: path:
    let
      localPath = ../config/. + "/${ref}/${path}";
    in
    builtins.readFile localPath;
  # stolen from https://github.com/Porcupine96/dotfiles/blob/298739a1f84eb44766c45e091960e41a30ef929f/config/nix/lib/gl_wrap.nix
  nixGLWrapper = pkgs: { bin, package ? pkgs."${bin}", output ? "" }:
    pkgs.callPackage
      (inputs:
        let
          pkg = if output == "" then (package.override inputs) else package."${output}";
        in
        pkgs.stdenv.mkDerivation {
          name = "${bin}";
          pname = "${bin}";
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p "$out/bin" "$out/share"
            # cp -pRL "${pkg}/share" "$out/"
            for f in '${pkg}'/share/*; do
              ln -s -t "$out/share/" "$f"
            done
            cat >> "$out/bin/${bin}" << EOF
            #!/usr/bin/env sh
            ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkg}/bin/${bin} "\$@"
            EOF
            chmod u+x  "$out/bin/${bin}"
          '';
        })
      { };

  nixVulkanWrapper = pkgs: { bin, package ? pkgs."${bin}" }:
    pkgs.callPackage
      (inputs:
        let pkg = (package.override inputs);
        in
        pkgs.stdenv.mkDerivation {
          name = "${bin}";
          pname = "${bin}";
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p "$out/bin" "$out/share"
            # cp -pRL "${pkg}/share" "$out/"
            for f in '${pkg}'/share/*; do # hello emacs */
            ln -s -t "$out/share/" "$f"
            done
            cat >> "$out/bin/${bin}" << EOF
            #!/usr/bin/env sh
            ${pkgs.nixgl.nixVulkanIntel}/bin/nixVulkanIntel ${pkg}/bin/${bin} "\$@"
            EOF
            chmod u+x  "$out/bin/${bin}"
          '';
        })
      { };

  nixBothWrapper = pkgs: { bin, package ? pkgs."${bin}" }:
    pkgs.callPackage
      (inputs:
        let pkg = (package.override inputs);
        in
        pkgs.stdenv.mkDerivation {
          name = "${bin}";
          pname = "${bin}";
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p "$out/bin" "$out/share"
            # cp -pRL "${pkg}/share" "$out/"
            for f in '${pkg}'/share/*; do # hello emacs */
            ln -s -t "$out/share/" "$f"
            done
            cat >> "$out/bin/${bin}" << EOF
            #!/usr/bin/env sh
            ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.nixgl.nixVulkanIntel}/bin/nixVulkanIntel ${pkg}/bin/${bin} "\$@"
            EOF
            chmod u+x  "$out/bin/${bin}"
          '';
        })
      { };

  ## Nginx Reverse Proxy
  createVirtualHosts = { subdomain, port, nginxCfg, extraLocations ? {}, extraConfig ? "" }: {
    # "${subdomain}.${nginxCfg.publicDomain}" = {
    #   useACMEHost = nginxCfg.localDomain;
    #   forceSSL = true;
    #   enableACME = false;
    #   http2 = true;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:${port}";
    #     proxyWebsockets = true;
    #   };
    #   inherit extraConfig;
    # };
    # "${subdomain}.${nginxCfg.legacyDomain}" = {
    #   useACMEHost = nginxCfg.legacyDomain;
    #   forceSSL = true;
    #   enableACME = false;
    #   http2 = true;
    #   locations."/" = {
    #     return = "301 https://${subdomain}.${nginxCfg.localDomain}";
    #   };
    # };
    "${subdomain}.${nginxCfg.localDomain}" = {
      useACMEHost = nginxCfg.localDomain;
      forceSSL = true;
      enableACME = false;
      http2 = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${port}";
          proxyWebsockets = true;
        };
      } // extraLocations;
      inherit extraConfig;
    };
  };

  mkBrowserApp = pkgs: { name, url }:
    pkgs.stdenv.mkDerivation {
      name = "${name}";
      pname = "${name}";
      phases = [ "installPhase" ];
      installPhase = ''
              mkdir -p $out/share/applications
              cat <<EOF > $out/share/applications/${name}.desktop
        [Desktop Entry]
        Name=${name}
        Comment=Play this game on a Browser
        Exec=${pkgs.chromium}/bin/chromium --app=${url} --start-fullscreen --disable-frame-rate-limit --use-angle=d3d9cd
        Terminal=false
        Type=Application
        Categories=Game;
        EOF
      '';
    };

  ## Flake Utils
  # System types to support.
  supportedSystems = [ "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];

  # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

  # Nixpkgs instantiated for supported system types.
  nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
}
