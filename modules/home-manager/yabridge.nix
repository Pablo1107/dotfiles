{ config, options, lib, myLib, pkgs-23_11, inputs, ... }:

with lib;
with inputs.nix-std.lib.serde;

let
  cfg = config.personal.yabridge;
in
{
  options.personal.yabridge = {
    enable = mkEnableOption "yabridge";

    # https://github.com/robbert-vdh/yabridge/blob/49e696e42f6a7dfff0af51feb4a3e42eeffacdca/tools/yabridgectl/src/config.rs#L71
    yabridge_home = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        The path to the directory containing `libyabridge-{chainloader,}-{clap,vst2,vst3}.so`. If not
        set, then yabridgectl will look in `/usr/lib` and `$XDG_DATA_HOME/yabridge` since those are
        the expected locations for yabridge to be installed in.
      '';
    };

    plugin_dirs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Directories to search for Windows VST plugins. These directories can contain VST2 plugin
        `.dll` files, VST3 modules (which should be located in `<prefix>/drive_c/Program
        Files/Common/VST3`), and CLAP plugins (which should similarly be installed to
        `<prefix>/drive_c/Program Files/Common/CLAP`). We're using an ordered set here out of
        convenience so we can't get duplicates and the config file is always sorted.
      '';
    };

    vst2_location = mkOption {
      type = types.enum [ "centralized" "inline" ];
      default = "centralized";
      description = ''
        Where VST2 plugins are setup. This can be either in `~/.vst/yabridge` or inline with the
        plugin's .dll` files.`:

         centralized:
         Set up the plugins in `~/.vst/yabridge`. The downside of this approach is that you cannot
         have multiple plugins with the same name being provided by multiple directories or prefixes.
         That might be useful for debugging purposes.
         Centralized,

         inline:
         Create the `.so` files right next to the original VST2 plugins.
      '';
    };

    no_verify = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Always skip post-installation setup checks. This can be set temporarily by passing the
        `--no-verify` option to `yabridgectl sync`.
      '';
    };

    blacklist = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        Files and directories that should be skipped during the indexing process. If this contains a
        directory, then everything under that directory will also be skipped. Like with
        `plugin_dirs`, we're using a `BTreeSet` here because it looks nicer in the config file, even
        though a hash set would make much more sense.
      '';
    };

    # last_known_config = mkOption {
    #   type = types.bool;
    #   default = null;
    #   description = ''
    #     The last known combination of Wine and yabridge versions that would work together properly.
    #     This is mostly to diagnose issues with older Wine versions (such as those in Ubuntu's repos)
    #     early on.
    #   '';
    # };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs-23_11; [
      yabridge
      yabridgectl
    ];

    home.file.".config/yabridgectl/config.toml".text = toTOML {
      inherit (cfg) plugin_dirs vst2_location no_verify blacklist;
    };

    home.activation.yabridgectlSync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs-23_11.yabridgectl}/bin/yabridgectl sync
    '';
  };
}
