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
        type = lib.types.enum [
          "ignore"
          "float"
          "tile"
        ];
        default = "ignore";
        description = "Window behavior: ignore, float or tile";
      };
      width_ratio = lib.mkOption {
        type = lib.types.nullOr lib.types.float;
        default = null;
        description = "Width ratio (0.0–1.0)";
      };
    };
  };

  keybindingsType = lib.types.attrsOf (lib.types.listOf lib.types.str);

  cleanRule = rule: lib.filterAttrs (_: v: v != null) rule;

  configJSON = builtins.toJSON (
    lib.filterAttrs (_: v: v != null) {
      default_width_ratio = cfg.settings.defaultWidthRatio;
      preset_width_ratios = cfg.settings.presetWidthRatios;

      # анимации
      animation_duration_ms = cfg.settings.animationDurationMs;
      keyboard_animation_ms = cfg.settings.keyboardAnimationMs;
      hover_focus_animation_ms = cfg.settings.hoverFocusAnimationMs;
      trackpad_settle_animation_ms = cfg.settings.trackpadSettleAnimationMs;
      move_column_animation_ms = cfg.settings.moveColumnAnimationMs;
      width_animation_ms = cfg.settings.widthAnimationMs;
      animation_curve = cfg.settings.animationCurve;

      # hover focus
      hover_to_focus = cfg.settings.hoverToFocus;
      hover_focus_delay_ms = cfg.settings.hoverFocusDelayMs;
      hover_focus_max_scroll_ratio = cfg.settings.hoverFocusMaxScrollRatio;
      hover_focus_requires_visible_ratio = cfg.settings.hoverFocusRequiresVisibleRatio;
      hover_focus_edge_trigger_width = cfg.settings.hoverFocusEdgeTriggerWidth;
      hover_focus_after_trackpad_ms = cfg.settings.hoverFocusAfterTrackpadMs;
      hover_focus_mode = cfg.settings.hoverFocusMode;

      # воркспейсы и позиция окон
      workspace_auto_back_and_forth = cfg.settings.workspaceAutoBackAndForth;
      center_focused_column = cfg.settings.centerFocusedColumn;
      focus_alignment = cfg.settings.focusAlignment;
      new_window_position = cfg.settings.newWindowPosition;

      # отступы
      inner_gap = cfg.settings.innerGap;
      outer_gap = cfg.settings.outerGap;
      parked_sliver_width = cfg.settings.parkedSliverWidth;

      # клавиши
      excluded_keybindings = cfg.settings.excludedKeybindings;
      keybindings = if cfg.settings.keybindings != { } then cfg.settings.keybindings else null;

      # трекпад
      trackpad_navigation = cfg.settings.trackpadNavigation;
      trackpad_navigation_fingers = cfg.settings.trackpadNavigationFingers;
      trackpad_navigation_sensitivity = cfg.settings.trackpadNavigationSensitivity;
      trackpad_navigation_deceleration = cfg.settings.trackpadNavigationDeceleration;
      trackpad_navigation_hover_suppression_ms = cfg.settings.trackpadNavigationHoverSuppressionMs;
      trackpad_navigation_momentum_min_velocity = cfg.settings.trackpadNavigationMomentumMinVelocity;
      trackpad_navigation_velocity_gain = cfg.settings.trackpadNavigationVelocityGain;
      trackpad_navigation_settle_animation_ms = cfg.settings.trackpadNavigationSettleAnimationMs;
      trackpad_navigation_snap = cfg.settings.trackpadNavigationSnap;
      trackpad_navigation_invert_x = cfg.settings.trackpadNavigationInvertX;
      trackpad_navigation_invert_y = cfg.settings.trackpadNavigationInvertY;

      # прочее
      rescan_interval_ms = cfg.settings.rescanIntervalMs;
      restore_on_exit = cfg.settings.restoreOnExit;
      persist_layout = cfg.settings.persistLayout;
      hide_method = cfg.settings.hideMethod;
      debug_logging = cfg.settings.debugLogging;

      rules = if cfg.settings.rules != [ ] then map cleanRule cfg.settings.rules else null;
    }
  );

in
{
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
        description = "Default column width ratio (0.0–1.0)";
      };

      presetWidthRatios = lib.mkOption {
        type = lib.types.listOf lib.types.float;
        default = [
          0.5
          0.67
          0.8
          1.0
        ];
        description = "Preset width ratios cycled by Cmd+Ctrl+H/L";
      };

      # --- анимации ---
      animationDurationMs = lib.mkOption {
        type = lib.types.int;
        default = 240;
        description = "Default animation duration ms";
      };

      keyboardAnimationMs = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Keyboard navigation animation ms (null = animationDurationMs)";
      };

      hoverFocusAnimationMs = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Hover focus animation ms";
      };

      trackpadSettleAnimationMs = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Trackpad settle animation ms";
      };

      moveColumnAnimationMs = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Move column animation ms";
      };

      widthAnimationMs = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Width change animation ms";
      };

      animationCurve = lib.mkOption {
        type = lib.types.enum [
          "smooth"
          "linear"
          "ease_in"
          "ease_out"
          "ease_in_out"
        ];
        default = "smooth";
        description = "Animation easing curve";
      };

      hoverToFocus = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Focus window on mouse hover";
      };

      hoverFocusDelayMs = lib.mkOption {
        type = lib.types.int;
        default = 120;
        description = "Hover focus delay ms";
      };

      hoverFocusMaxScrollRatio = lib.mkOption {
        type = lib.types.float;
        default = 0.15;
        description = "Max scroll ratio to trigger hover focus";
      };

      hoverFocusRequiresVisibleRatio = lib.mkOption {
        type = lib.types.float;
        default = 0.15;
        description = "Required visible ratio for hover focus";
      };

      hoverFocusEdgeTriggerWidth = lib.mkOption {
        type = lib.types.int;
        default = 8;
        description = "Edge trigger width px for hover focus";
      };

      hoverFocusAfterTrackpadMs = lib.mkOption {
        type = lib.types.int;
        default = 280;
        description = "Suppress hover focus after trackpad gesture ms";
      };

      hoverFocusMode = lib.mkOption {
        type = lib.types.enum [
          "edge_or_visible"
          "always"
          "edge_only"
        ];
        default = "edge_or_visible";
        description = "When to activate hover focus";
      };

      workspaceAutoBackAndForth = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Re-pressing workspace shortcut returns to previous workspace";
      };

      centerFocusedColumn = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Keep focused column centered on screen";
      };

      focusAlignment = lib.mkOption {
        type = lib.types.enum [
          "smart"
          "left"
          "center"
          "right"
        ];
        default = "smart";
        description = "Where to align focused column";
      };

      newWindowPosition = lib.mkOption {
        type = lib.types.enum [
          "after_active"
          "start"
          "end"
        ];
        default = "after_active";
        description = ''
          Where new windows are placed.
          "after_active" — Default.
          "end" — Disable.
          "start" — At start.
        '';
      };

      innerGap = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Gap between columns px";
      };

      outerGap = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Gap between columns and screen edge px";
      };

      parkedSliverWidth = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Width of parked/hidden column sliver px";
      };

      excludedKeybindings = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "cmd+shift+5" ];
        description = "Keybindings miri won't intercept";
      };

      keybindings = lib.mkOption {
        type = keybindingsType;
        default = { };
        description = "Override default keybindings. Key is action name, value is list of shortcuts.";
        example = lib.literalExpression ''
          {
            focus_workspace_1 = [ "cmd+1" ];
            column_left       = [ "cmd+h" ];
            column_right      = [ "cmd+l" ];
          }
        '';
      };

      trackpadNavigation = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable trackpad horizontal navigation";
      };

      trackpadNavigationFingers = lib.mkOption {
        type = lib.types.int;
        default = 3;
        description = "Number of fingers for trackpad navigation";
      };

      trackpadNavigationSensitivity = lib.mkOption {
        type = lib.types.float;
        default = 1.6;
        description = "Trackpad navigation sensitivity";
      };

      trackpadNavigationDeceleration = lib.mkOption {
        type = lib.types.float;
        default = 5.5;
        description = "Trackpad navigation deceleration";
      };

      trackpadNavigationHoverSuppressionMs = lib.mkOption {
        type = lib.types.int;
        default = 280;
        description = "Suppress hover focus after trackpad navigation ms";
      };

      trackpadNavigationMomentumMinVelocity = lib.mkOption {
        type = lib.types.int;
        default = 80;
        description = "Minimum velocity to start momentum scrolling";
      };

      trackpadNavigationVelocityGain = lib.mkOption {
        type = lib.types.float;
        default = 1.35;
        description = "Trackpad velocity gain multiplier";
      };

      trackpadNavigationSettleAnimationMs = lib.mkOption {
        type = lib.types.int;
        default = 240;
        description = "Trackpad settle animation ms";
      };

      trackpadNavigationSnap = lib.mkOption {
        type = lib.types.enum [
          "nearest_column"
          "none"
        ];
        default = "nearest_column";
        description = "Snap behaviour after trackpad gesture ends";
      };

      trackpadNavigationInvertX = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Invert trackpad horizontal direction";
      };

      trackpadNavigationInvertY = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Invert trackpad vertical direction";
      };

      rescanIntervalMs = lib.mkOption {
        type = lib.types.int;
        default = 1000;
        description = "How often miri rescans windows ms";
      };

      restoreOnExit = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Restore window layout on exit";
      };

      persistLayout = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Persist layout across reboots";
      };

      hideMethod = lib.mkOption {
        type = lib.types.enum [
          "skylight_alpha"
          "minimize"
        ];
        default = "skylight_alpha";
        description = "How miri hides parked windows";
      };

      debugLogging = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable debug logging";
      };

      rules = lib.mkOption {
        type = lib.types.listOf ruleType;
        default = [
          {
            bundle_id = "com.apple.finder";
            behavior = "ignore";
          }
        ];
        description = "Per-app window rules";
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
