{ config, lib, ... }:

let
  cfg = config.programs.miri;

  ruleType = lib.types.submodule {
    options = {
      bundle_id = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "macOS bundle ID (e.g: com.apple.finder)";
      };
      app_name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "App name";
      };
      title_contains = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Title contains";
      };
      behavior = lib.mkOption {
        type = lib.types.enum [ "ignore" "float" "tile" ];
        default = "ignore";
        description = "Window behavior: ignore, float или tile";
      };
      width_ratio = lib.mkOption {
        type = lib.types.nullOr lib.types.float;
        default = null;
        description = "Width ratio (0.0–1.0)";
      };
    };
  };

  cleanRule = rule:
    lib.filterAttrs (_: v: v != null) rule;

  configJSON = builtins.toJSON (
    lib.filterAttrs (_: v: v != null) {
      default_width_ratio = cfg.settings.defaultWidthRatio;
      preset_width_ratios = cfg.settings.presetWidthRatios;
      animation_duration_ms = cfg.settings.animationDurationMs;
      hover_to_focus = cfg.settings.hoverToFocus;
      hover_focus_delay_ms = cfg.settings.hoverFocusDelayMs;
      hover_focus_max_scroll_ratio = cfg.settings.hoverFocusMaxScrollRatio;
      workspace_auto_back_and_forth = cfg.settings.workspaceAutoBackAndForth;
      center_focused_column = cfg.settings.centerFocusedColumn;
      excluded_keybindings = cfg.settings.excludedKeybindings;
      rules = if cfg.settings.rules != [] then map cleanRule cfg.settings.rules else null;
    }
  );

in {
  options.programs.miri = {
    enable = lib.mkEnableOption "miri window manager for macOS";

    package = lib.mkOption {
      type = lib.types.package;
      description = "Miri package";
    };

    launchAtLogin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Launch at login";
    };

    settings = {
      defaultWidthRatio = lib.mkOption {
        type = lib.types.float;
        default = 0.8;
        description = "Window width";
      };

      presetWidthRatios = lib.mkOption {
        type = lib.types.listOf lib.types.float;
        default = [ 0.5 0.67 0.8 1.0 ];
        description = "Preset width ratios: Cmd+Ctrl+H/L";
      };

      animationDurationMs = lib.mkOption {
        type = lib.types.int;
        default = 180;
        description = "Animation duration ms";
      };

      hoverToFocus = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Hover to focus";
      };

      hoverFocusDelayMs = lib.mkOption {
        type = lib.types.int;
        default = 120;
        description = "Hover focus delay ms";
      };

      hoverFocusMaxScrollRatio = lib.mkOption {
        type = lib.types.float;
        default = 0.15;
        description = "Hover focus max scroll ratio";
      };

      workspaceAutoBackAndForth = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Workspace auto back and forth";
      };

      centerFocusedColumn = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Center Focused Column";
      };

      excludedKeybindings = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "cmd+shift+5" ];
        description = "Excluded keybindings";
      };

      rules = lib.mkOption {
        type = lib.types.listOf ruleType;
        default = [
          { bundle_id = "com.apple.finder"; behavior = "ignore"; }
        ];
        description = "Rules for apps";
        example = lib.literalExpression ''
          [
            { bundle_id = "com.apple.finder"; behavior = "ignore"; }
            { app_name = "Telegram"; behavior = "float"; }
            { bundle_id = "com.brave.Browser"; width_ratio = 1.0; behavior = "tile"; }
          ]
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."miri/config.json".text = configJSON;

    launchd.agents.miri = lib.mkIf cfg.launchAtLogin {
      enable = true;
      config = {
        ProgramArguments = [ "${cfg.package}/bin/miri" ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/miri.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/miri.error.log";
      };
    };
  };
}
