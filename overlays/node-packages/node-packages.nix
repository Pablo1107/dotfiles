# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "@vscode/l10n-0.0.18" = {
      name = "_at_vscode_slash_l10n";
      packageName = "@vscode/l10n";
      version = "0.0.18";
      src = fetchurl {
        url = "https://registry.npmjs.org/@vscode/l10n/-/l10n-0.0.18.tgz";
        sha512 = "KYSIHVmslkaCDyw013pphY+d7x1qV8IZupYfeIfzNA+nsaWHbn5uPuQRvdRFsa9zFzGeudPuoGoZ1Op4jrJXIQ==";
      };
    };
    "@vtsls/language-service-0.2.1" = {
      name = "_at_vtsls_slash_language-service";
      packageName = "@vtsls/language-service";
      version = "0.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/@vtsls/language-service/-/language-service-0.2.1.tgz";
        sha512 = "hx4RP4LiJcRZ1x8MjkdJ551DANhwEuduEyEYGS2mcpTDsv1cciCpxwn4rYCqE7s96r1FmHplmR9cdRo1RnIbdA==";
      };
    };
    "@vtsls/vscode-fuzzy-0.0.1" = {
      name = "_at_vtsls_slash_vscode-fuzzy";
      packageName = "@vtsls/vscode-fuzzy";
      version = "0.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/@vtsls/vscode-fuzzy/-/vscode-fuzzy-0.0.1.tgz";
        sha512 = "2KCtA+/OmPVttsdVggO0WQFXZwM0zbG7G8KRGExe4YeoaHB0fDWyfsNrWnutnFVRlpmu8quVTjTI15YK6KGCFw==";
      };
    };
    "jsonc-parser-3.2.1" = {
      name = "jsonc-parser";
      packageName = "jsonc-parser";
      version = "3.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.2.1.tgz";
        sha512 = "AilxAyFOAcK5wA1+LeaySVBrHsGQvUFCDWXKpZjzaL0PqW+xfBOttn8GNtWKFWqneyMZj41MWF9Kl6iPWLwgOA==";
      };
    };
    "lru-cache-6.0.0" = {
      name = "lru-cache";
      packageName = "lru-cache";
      version = "6.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz";
        sha512 = "Jo6dJ04CmSjuznwJSS3pUeWmd/H0ffTlkXXgwZi+eq1UCmqQwCh+eLsYOYCwY991i2Fah4h1BEMCx4qThGbsiA==";
      };
    };
    "semver-7.5.2" = {
      name = "semver";
      packageName = "semver";
      version = "7.5.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver/-/semver-7.5.2.tgz";
        sha512 = "SoftuTROv/cRjCze/scjGyiDtcUyxw1rgYQSZY7XTmtR5hX+dm76iDbTH8TkLPHCQmlbQVSSbNZCPM2hb0knnQ==";
      };
    };
    "typescript-5.4.2" = {
      name = "typescript";
      packageName = "typescript";
      version = "5.4.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/typescript/-/typescript-5.4.2.tgz";
        sha512 = "+2/g0Fds1ERlP6JsakQQDXjZdZMM+rqpamFZJEKh4kwTIn3iDkgKtby0CeNd5ATNZ4Ry1ax15TMx0W2V+miizQ==";
      };
    };
    "vscode-jsonrpc-8.2.0" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "8.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-8.2.0.tgz";
        sha512 = "C+r0eKJUIfiDIfwJhria30+TYWPtuHJXHtI7J0YlOmKAo7ogxP20T0zxB7HZQIFhIyvoBPwWskjxrvAtfjyZfA==";
      };
    };
    "vscode-languageserver-9.0.1" = {
      name = "vscode-languageserver";
      packageName = "vscode-languageserver";
      version = "9.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-9.0.1.tgz";
        sha512 = "woByF3PDpkHFUreUa7Hos7+pUWdeWMXRd26+ZX2A8cFx6v/JPTtd4/uN0/jB6XQHYaOlHbio03NTHCqrgG5n7g==";
      };
    };
    "vscode-languageserver-protocol-3.17.5" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.17.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.17.5.tgz";
        sha512 = "mb1bvRJN8SVznADSGWM9u/b07H7Ecg0I3OgXDuLdn307rl/J3A9YD6/eYOssqhecL27hK1IPZAsaqh00i/Jljg==";
      };
    };
    "vscode-languageserver-textdocument-1.0.11" = {
      name = "vscode-languageserver-textdocument";
      packageName = "vscode-languageserver-textdocument";
      version = "1.0.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.11.tgz";
        sha512 = "X+8T3GoiwTVlJbicx/sIAF+yuJAqz8VvwJyoMVhwEMoEKE/fkDmrqUgDMyBECcM2A2frVZIUj5HI/ErRXCfOeA==";
      };
    };
    "vscode-languageserver-types-3.17.5" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.17.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.17.5.tgz";
        sha512 = "Ld1VelNuX9pdF39h2Hgaeb5hEZM2Z3jUrrMgWQAu82jMtZp7p3vJT3BzToKtZI7NgQssZje5o0zryOrhQvzQAg==";
      };
    };
    "vscode-uri-3.0.8" = {
      name = "vscode-uri";
      packageName = "vscode-uri";
      version = "3.0.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.8.tgz";
        sha512 = "AyFQ0EVmsOZOlAnxoFOGOq1SQDWAB7C6aqMGS23svWAllfOaxbuFvcT8D1i8z3Gyn8fraVeZNNmN6e9bxxXkKw==";
      };
    };
    "yallist-4.0.0" = {
      name = "yallist";
      packageName = "yallist";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz";
        sha512 = "3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==";
      };
    };
  };
in
{
  "@vtsls/language-server" = nodeEnv.buildNodePackage {
    name = "_at_vtsls_slash_language-server";
    packageName = "@vtsls/language-server";
    version = "0.2.1";
    src = fetchurl {
      url = "https://registry.npmjs.org/@vtsls/language-server/-/language-server-0.2.1.tgz";
      sha512 = "6u70jGgS101PMbP0L6OssNVs0G03+tFvWrNi+BkovnrsoLWVuJjg+rZ/QEJboHvRorI7iQ0sJ9QnExzovcS6vg==";
    };
    dependencies = [
      sources."@vscode/l10n-0.0.18"
      sources."@vtsls/language-service-0.2.1"
      sources."@vtsls/vscode-fuzzy-0.0.1"
      sources."jsonc-parser-3.2.1"
      sources."lru-cache-6.0.0"
      sources."semver-7.5.2"
      sources."typescript-5.4.2"
      sources."vscode-jsonrpc-8.2.0"
      sources."vscode-languageserver-9.0.1"
      sources."vscode-languageserver-protocol-3.17.5"
      sources."vscode-languageserver-textdocument-1.0.11"
      sources."vscode-languageserver-types-3.17.5"
      sources."vscode-uri-3.0.8"
      sources."yallist-4.0.0"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "LSP wrapper for typescript extension of vscode";
      homepage = "https://github.com/yioneko/vtsls#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
