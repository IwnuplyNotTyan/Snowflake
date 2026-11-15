{ pkgsUnstable, config, lib, pkgs, ... }:

#let
#  vicinaeStoreExtensions = pkgs.fetchFromGitHub {
#    owner = "vicinaehq";
#    repo = "extensions";
#    rev = "main";
#    hash = "sha256-cOB8raCDjTmvNgEYsZ/ctvojMx6As1Sr71mXaiVHGzo=";
#  };
#in

{
  programs.vicinae = {
    enable = true;

    package = pkgsUnstable.vicinae;

  #  extensions = [
    # ─── Raycast Store ────────────────────────────────────────────
    #(config.lib.vicinae.mkRayCastExtension {
    #  name = "nixpkgs-search";
    #  rev = "main";
    #})

    #(config.lib.vicinae.mkRayCastExtension {
    #  name = "kaomoji-search";
    #  rev = "main";
    #})

    #(config.lib.vicinae.mkRayCastExtension {
    #  name = "unicode-symbols";
    #  rev = "main";
    #})

    # ─── Vicinae Store ────────────────────────────────────────────
  #  (config.lib.vicinae.mkExtension {
  #    name = "player-pilot";
  #    src = "${vicinaeStoreExtensions}/extensions/player-pilot";
  #  })

  #  (config.lib.vicinae.mkExtension {
  #    name = "wiktionary";
  #    src = "${vicinaeStoreExtensions}/extensions/wiktionary";
  #  })
  #
    # ─── Github ──────────────────────────────────────────────────
  #  (config.lib.vicinae.mkExtension {
  #    name = "ffmpeg-recoreder";
  #    src = pkgs.fetchFromGitHub {
  #	owner = "iwnuplynottyan";
  #  	repo = "vicinaeffmpeg";
  #  	rev = "0d0fd9170e3cef665e2b28a38e5cbdb153e61a7c";
  #  	hash = "sha256-snFxRDkDHQ2F1uxbKI+8inlD3hmeJOzz7UcYQ8hUifU=";
  #  };
  #})
  #];

    settings = {
      close_on_focus_loss = true;
      favicon_service = "twenty";

      font = {
        normal = {
          family = "Iosevka Nerd Font";
          size = 12;
        };
      };

      global_shortcuts = {
      	toggle = "";
      };

      theme = {
        dark = {
          name = "vicinae-dark";
	  icon_theme = "WhiteSur-dark";
        };
      };

      launcher_window = {
        opacity = 1;
        client_side_decorations = {
          enabled = true;
        };
      };

      favorites = [
        "applications:org.telegram"
        "applications:chromium"
        "@iwnuplynottyan/ffmpeg-recoreder:ffmpegsr"
        "clipboard:history"
      ];

      providers = {
        "@dagimg-dot/store.vicinae.player-pilot" = {
          entrypoints = {
            "next-track".enabled = false;
            "pause-track".enabled = false;
            "previous-track".enabled = false;
            "resume-track".enabled = false;
          };
        };

        "@knoopx/store.vicinae.nix" = {
          enabled = false;
        };

        applications = {
          entrypoints = {
            "Vernal Edge".enabled = false;
	    "nvim".enabled = false;
	    "avahi-discover".enabled = false;
            "bottom".enabled = false;
            "bssh".enabled = false;
            "bvnc".enabled = false;
            "cups".enabled = false;
            "lstopo".enabled = false;
            "mpv".enabled = false;
            "nm-connection-editor".enabled = false;
            "qv4l2".enabled = false;
            "qvidcap".enabled = false;
            "stoken-gui".enabled = false;
            "stoken-gui-small".enabled = false;
            "syncthing-ui".enabled = false;
            "uxterm".enabled =false;
            "vicinae".enabled = false;
            "xterm".enabled = false;
          };
        };

        "browser-extension".enabled = false;
        calculator.enabled = false;

        core = {
          entrypoints = {
            about.enabled = false;
            documentation.enabled = false;
            "keybind-settings".enabled = false;
            "list-extensions".enabled = false;
            "manage-fallback".enabled = false;
            "oauth-token-store".enabled = false;
            "open-config-file".enabled = false;
            "open-default-config".enabled = false;
            "prune-memory".enabled = false;
            "report-bug".enabled = false;
            "search-builtin-icons".enabled = true;
            sponsor.enabled = false;
          };
        };

        developer.enabled = false;

        font = {
          entrypoints = {
            browse.enabled = false;
          };
        };

        "manage-shortcuts".enabled = false;

        theme = {
          entrypoints = {
            set.enabled = false;
          };
        };

        wm.enabled = false;
      };
    };
  };

  home.file.".local/share/vicinae/scripts/monitor.sh" = {
    executable = true;
    text = ''
#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Monitor Sleep
# @vicinae.mode compact

xset dpms force off
  '';};
}
