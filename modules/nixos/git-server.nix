{ config, options, lib, pkgs, rootPath, ... }:

with lib;

let
  cfg = config.personal.git-server;
  nginxCfg = config.personal.reverse-proxy;
  authorizedKeys = lib.splitString "\n" (builtins.readFile (rootPath + /config/ssh/.ssh/authorized_keys));
  domain = "git.${nginxCfg.localDomain}";
in
{
  options.personal.git-server = {
    enable = mkEnableOption "git-server";
  };

  config = mkIf cfg.enable {
    services.cgit.git = {
      enable = true;
      nginx.virtualHost = domain;
      scanPath = "/srv/git";
      settings = {
        enable-index-owner = false;
        enable-http-clone = true;
        enable-commit-graph = true;
      };
      extraConfig = ''
        robots=noindex, nofollow
      '';
    };

    services.nginx.virtualHosts.${domain} = {
      useACMEHost = nginxCfg.localDomain;
      forceSSL = true;
      enableACME = false;
    };

    users.users.git = {
      # group = "git";
      isNormalUser = true;
      home = "/srv/git";
      shell = "${pkgs.git}/bin/git-shell";
      openssh.authorizedKeys.keys = authorizedKeys;
      hashedPassword = "$y$j9T$LjnlfD3.zXLMqTZ00Rl2p0$SDavtIWFF1ZgjRu6hH59bngEimTwaZg4kpv80GzyhQ.";
    };

    # users.users.pablo.extraGroups = [ "git" ];
  };
}
