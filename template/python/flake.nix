{
  description = "Description for the project";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs@{ flake-parts, devenv-root, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;

        devenv.shells.default = {
          # https://devenv.sh/basics/
          env.GREET = "devenv";

          # https://devenv.sh/packages/
          packages = with pkgs;
          let
            tex = (texlive.combine {
              inherit (texlive) scheme-small
                wrapfig amsmath ulem hyperref capt-of
                newverbs tikzpagenodes ifoddpage
                dvipng minted fvextra catchfile
                xstring framed a4wide svg trimspaces
                transparent tocbibind microtype stix
                geometry
                ;
            });
          in [
            git
            emacs
            tex
            pandoc
          ];

          # https://devenv.sh/languages/
          languages.python = {
            enable = true;
            venv = {
              enable = true;
              requirements = ./requirements.txt;
            };
          };

          # https://devenv.sh/processes/
          # processes.cargo-watch.exec = "cargo-watch";

          # https://devenv.sh/services/
          # services.postgres.enable = true;

          # https://devenv.sh/scripts/
          scripts.hello.exec = ''
            echo hello from $GREET
          '';

          enterShell = ''
            hello
            git --version
          '';

          # https://devenv.sh/tasks/
          # tasks = {
          #   "myproj:setup".exec = "mytool build";
          #   "devenv:enterShell".after = [ "myproj:setup" ];
          # };

          # https://devenv.sh/tests/
          enterTest = ''
            echo "Running tests"
            git --version | grep --color=auto "${pkgs.git.version}"
          '';

          # https://devenv.sh/git-hooks/
          # git-hooks.hooks.shellcheck.enable = true;

          # See full reference at https://devenv.sh/reference/options/
        };

      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
