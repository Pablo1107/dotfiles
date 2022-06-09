{ config, pkgs, ... }:

with pkgs;

let
  shellAliases = {
    # Default aliases
    sudo = "sudo ";
    ls = "ls --color=auto";
    la = "ls -lah --group-directories-first";
    df = "df -h";
    vim = "nvim";
    td = "date +%Y-%m-%d";
    c = "clear";
    mux = "tmuxinator";
    "," = "NIX_AUTO_RUN=1 ";
    ssh = "TERM=xterm-256color ssh ";
  };

  sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    LESSHISTFILE = "-";

    NPM_PACKAGES = "$HOME/.npm-packages";
    PATH = "$HOME/dotfiles/bin:$HOME/scripts:$HOME/.local/bin/:$NPM_PACKAGES/bin:$HOME/.emacs.d/bin:$PATH";
    MANPATH = "\${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man";
    TMUX_SCRIPTS_DIR = "$HOME/dotfiles/config/tmux/scripts";

    DICPATH = "$DICPATH:$HOME/.nix-profile/share/hunspell:$HOME/nix-profile/share/myspell";

    LEDGER_FILE = "$HOME/ledger/all.journal";
  };

  getDotfile = with builtins; ref: path:
    let
      localPath = ../. + "/${ref}/${path}";
    in
    readFile localPath;

  keyBindings = getDotfile "zsh" "key-bindings.zsh";
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # personal modules
  personal.fzf.enable = true;
  personal.git.enable = true;
  personal.nix.enable = true;
  personal.ssh.enable = true;
  personal.python.enable = true;

  home.sessionVariables = sessionVariables;

  home.packages = [
    stow
    htop
    pure-prompt
    tree
    fd
    silver-searcher
    ripgrep
    tmuxinator
    jq
    vifm

    element-desktop

    #texlive.combined.scheme-full
    #anki
    #slack
    hledger
    tealdeer
    ffmpeg-full

    awscli2
    # aws-sam-cli

    # Node
    # (yarn.override { nodejs = nodejs-12_x; })
    yarn
    # (yarn.override { nodejs = nodejs-12_x; })
    # nodejs
    nodejs-14_x
    deno
    efm-langserver

    # Fonts
    #noto-fonts
    #noto-fonts-cjk
    #noto-fonts-emoji
    #hack-font
    #font-awesome
    #dejavu_fonts
    #ibm-plex
    #symbola
    #material-design-icons

    # AWS
    git-remote-codecommit

    # Databases

    # LSP
    rnix-lsp
    nodePackages.typescript-language-server

    # Rust
    # rustup

    docker-compose
    tesseract
    pandoc
    # mongodb-compass

    man-pages
    # clang

    hicolor-icon-theme
  ];

  # vifm
  home.file.".config/vifm/vifmrc".text = getDotfile "vifm" "vifmrc";

  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      history.extended = true;
      history.size = 10000000;
      shellAliases = shellAliases;
      autocd = true;

      initExtra = keyBindings + ''
        fpath+=${pure-prompt}/share/zsh/site-functions
        autoload -U promptinit;
        promptinit
          prompt pure
 
          eval "$(${pkgs.z-lua}/bin/z --init zsh)"
      '';

      loginExtra = ''
        setopt extendedglob
        setopt appendhistory
        setopt autocd
      '';

      # sessionVariables = sessionVariables;
    };

    bash = {
      enable = true;
      # sessionVariables = sessionVariables;
      shellAliases = shellAliases;
    };

    fzf = {
      enable = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
      fileWidgetCommand = "$FZF_DEFAULT_COMMAND";
      defaultOptions = [
        "--bind tab:toggle-out,shift-tab:toggle-in"
        "--bind alt-j:down,alt-k:up,ctrl-j:preview-down,ctrl-k:preview-up"
        "--color=dark"
        "--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f"
        "--color=info:#7aa6da,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
      ];
    };
    command-not-found.enable = true;
    tmux = {
      enable = true;
      extraConfig = getDotfile "tmux" ".tmux.conf";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
