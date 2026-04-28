{ pkgs, lib, ... }:

let
  mod = "Mod4";
  ws1  = "1";
  ws2  = "2";
  ws3  = "3";
  ws4  = "4";
  ws5  = "5";
  ws6  = "6";
  ws7  = "7";
  ws8  = "8";
  ws9  = "9";
  ws10 = "10";
in
{

  home.packages = with pkgs; [
    maim
    xclip
    xdotool

    pulseaudio

    xorg.setxkbmap

    picom
    feh
    warpd

    mpd

    syncthing

    kitty

    (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })

    # vicinae
  ];

  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = mod;

      fonts = {
        names = [ "Iosevka Nerd Font" ];
        size  = 11.0;
      };

      terminal = "kitty";

      defaultBorder = "pixel 0";

      gaps = {
        inner = 6;
      };

      floating.modifier = mod;

      keybindings = lib.mkOptionDefault {

        #"${mod}+Return" = "exec --no-startup-id kitty";

        "${mod}+q" = "kill";

        "${mod}+space" = "exec --no-startup-id vicinae open";

        "${mod}+l" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+j" = "focus up";
        "${mod}+h" = "focus right";

        "${mod}+Left"  = "focus left";
        "${mod}+Down"  = "focus down";
        "${mod}+Up"    = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+Shift+l" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+h" = "move right";

        "${mod}+Shift+Left"  = "move left";
        "${mod}+Shift+Down"  = "move down";
        "${mod}+Shift+Up"    = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+y" = "split h";
        "${mod}+u" = "split v";

        "${mod}+f" = "fullscreen toggle";

        "${mod}+Shift+space" = "floating toggle";
        "${mod}+d"           = "focus mode_toggle";
        "${mod}+a"           = "focus parent";

        "${mod}+1" = "workspace ${ws1}";
        "${mod}+2" = "workspace ${ws2}";
        "${mod}+3" = "workspace ${ws3}";
        "${mod}+4" = "workspace ${ws4}";
        "${mod}+5" = "workspace ${ws5}";
        "${mod}+6" = "workspace ${ws6}";
        "${mod}+7" = "workspace ${ws7}";
        "${mod}+8" = "workspace ${ws8}";
        "${mod}+9" = "workspace ${ws9}";
        "${mod}+0" = "workspace ${ws10}";

        "${mod}+Shift+1" = "move container to workspace ${ws1}";
        "${mod}+Shift+2" = "move container to workspace ${ws2}";
        "${mod}+Shift+3" = "move container to workspace ${ws3}";
        "${mod}+Shift+4" = "move container to workspace ${ws4}";
        "${mod}+Shift+5" = "move container to workspace ${ws5}";
        "${mod}+Shift+6" = "move container to workspace ${ws6}";
        "${mod}+Shift+7" = "move container to workspace ${ws7}";
        "${mod}+Shift+8" = "move container to workspace ${ws8}";
        "${mod}+Shift+9" = "move container to workspace ${ws9}";
        "${mod}+Shift+0" = "move container to workspace ${ws10}";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = ''
          exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"
        '';

        "${mod}+r" = "mode resize";

        "${mod}+p"       = "exec --no-startup-id maim | xclip -selection clipboard -t image/png";

        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute"        = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute"     = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";
      };

      modes = {
        resize = {
          "j"      = "resize shrink width 10 px or 10 ppt";
          "k"      = "resize grow height 10 px or 10 ppt";
          "l"      = "resize shrink height 10 px or 10 ppt";
          "semicolon" = "resize grow width 10 px or 10 ppt";

          "Left"   = "resize shrink width 3 px or 3 ppt";
          "Down"   = "resize grow height 3 px or 3 ppt";
          "Up"     = "resize shrink height 3 px or 3 ppt";
          "Right"  = "resize grow width 3 px or 3 ppt";

          "Return" = "mode default";
          "Escape" = "mode default";
          "${mod}+r" = "mode default";
        };
      };

      window.commands = [
        { criteria = { class = ".*"; }; command = "border pixel 0"; }

        { criteria = { class = "vicinae"; }; command = "floating enable, sticky enable"; }
      ];

      startup = [
        {
          command = "setxkbmap -model pc104 -layout us,ru -option grp:alt_space_toggle";
          always  = true;
          notification = false;
        }
        {
          command = "picom -b";
          always  = true;
          notification = false;
        }
        {
          command = "warpd";
          always  = true;
          notification = false;
        }
        {
          command = "feh --bg-fill ~/files/media/wal/wallhaven-gjwg7l_1920x1080-sovonegr.png";
          always  = true;
          notification = false;
        }
        {
          command = "mpd --no-daemon";
          always  = true;
          notification = false;
        }
        {
          command = "vicinae server";
          always  = true;
          notification = false;
        }
        {
          command = "syncthing --no-browser";
          always  = true;
          notification = false;
        }
      ];
    };
  };
}
