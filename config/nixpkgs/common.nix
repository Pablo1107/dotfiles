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

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "pablo";
    homeDirectory = "/Users/pablo";
    sessionVariables = sessionVariables;
  };

  home.packages = [
    neovim
    stow
    htop
    alacritty
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
    haskellPackages.hledger_1_24_1
    tealdeer
    ffmpeg-full

    # Python
    python.pkgs.pip
    (
      python39.withPackages (
        ps: with ps; [
          tkinter
          setuptools
          wheel
          pynvim
          requests
          selenium
          jinja2
          ply
          pyaml
          numpy
          sympy
          pygments
          matplotlib
          seaborn
          pandas-datareader
          requests-cache
          plotly
        ]
      )
    )

    awscli2

    # Node
    # (yarn.override { nodejs = nodejs-12_x; })
    yarn
    # (yarn.override { nodejs = nodejs-12_x; })
    # nodejs
    nodejs-14_x
    deno
    nur.repos.crazazy.efm-langserver

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

    # Rust
    # rustup

    docker-compose
    tesseract
    pandoc
    # mongodb-compass

    man-pages
    # clang

    hicolor-icon-theme
    #emacsPgtk
  ];

  # nix
  home.file.nixConf.text = ''
    build-users-group = nixbld
    system = aarch64-darwin
    extra-platforms = x86_64-darwin aarch64-darwin
    experimental-features = nix-command flakes
  '';

  # vifm
  home.file.".config/vifm/vifmrc".text = getDotfile "vifm" "vifmrc";

  # home.file.".config/vifm/colors/solarized-dark.vifm".text = getDotfile "vifm" "colors/solarized-dark.vifm";
  # home.file.".local/bin/wl-screenshot".source = writeScript "wl-screenshot" (getDotfile "scripts" "wl-screenshot");
  # home.file.".local/bin/git-status".source = writeScript "git-status" (getDotfile "scripts" "git-status");

  programs = {
    git = {
      enable = true;
      userName = "Pablo Andres Dealbera";
      userEmail = "dealberapablo07@gmail.com";
      aliases = {
        fza = "!git ls-files -m -o --exclude-standard | fzf --print0 -m | xargs -0 -t -o git add";
      };
      extraConfig = {
        push.followTags = true; # always push tags when "git push"
        credential = {
          helper = "store";
        };
        # pager.show = "nvim -R -c '%sm/\\e.\\{-}m//ge' +1 -";
        diff.tool = "nvimdiff";
        difftool.nvimdiff.cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
        # difftool.prompt = false;
        url."ssh://git@github.com/".insteadOf = "https://github.com/";
      };
    };

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

      profileExtra = ''
        . /etc/profile
      '';

      # sessionVariables = sessionVariables;
    };

    bash = {
      enable = true;
      # sessionVariables = sessionVariables;
      shellAliases = shellAliases;
    };

    ssh = {
      enable = true;
      extraConfig = ''
        Host github.com
        Hostname ssh.github.com
        Port 443
      '';
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
    htop = {
      enable = true;
      settings = {
        hideThreads = true;
        hideUserlandThreads = true;
        showCpuUsage = true;
        showProgramPath = false;
        vimMode = true;
        fields = with config.lib.htop.fields; [
          PID
          USER
          PRIORITY
          NICE
          M_SIZE
          M_RESIDENT
          M_SHARE
          STATE
          PERCENT_CPU
          PERCENT_MEM
          TIME
          COMM
        ];
        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;
      } // (with config.lib.htop; leftMeters [
        (bar "LeftCPUs2")
        (bar "Memory")
        (bar "Swap")
      ]) // (with config.lib.htop; rightMeters [
        (bar "RightCPUs2")
        (text "Tasks")
        (text "LoadAverage")
      ]);
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
