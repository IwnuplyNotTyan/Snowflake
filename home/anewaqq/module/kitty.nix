{ pkgs, lib, isDarwin ? false, ... }:

{
  programs.kitty = {
    enable = true;



    settings = {
      # Display
      linux_display_server  = "x11";
      x11_titlebar_color    = "background";

      # Font
      font_family      = "Iosevka Nerd Font";
      bold_font        = "auto";
      italic_font      = "auto";
      bold_italic_font = "auto";
      font_size        = 18;

      # Window
      window_padding_width = 4;

      # Cursor
      cursor           = "#e3e1e4";
      cursor_text_color = "background";

      # Selection
      selection_background = "#423f46";
      selection_foreground = "#e3e1e4";

      # URL
      url_color = "#5de4c7";

      # Window borders
      active_border_color   = "#3d59a1";
      inactive_border_color = "#101014";
      bell_border_color     = "#fffac2";

      # Tabs
      active_tab_background    = "#2d2a2e";
      active_tab_foreground    = "#e3e1e4";
      active_tab_font_style    = "bold";
      inactive_tab_background  = "#2d2a2e";
      inactive_tab_foreground  = "#e3e1e4";
      inactive_tab_font_style  = "normal";

      # Colors
      foreground = "#c5c8c9";
      background = "#0B0F10";

      # Black
      color0 = "#101415";
      color8 = "#131718";

      # Red
      color1 = "#df5b61";
      color9 = "#ee6a70";

      # Green
      color2  = "#87c7a1";
      color10 = "#96d6b0";

      # Yellow
      color3  = "#de8f78";
      color11 = "#ffb29b";

      # Blue
      color4  = "#6791c9";
      color12 = "#7ba5dd";

      # Magenta
      color5  = "#bc83e3";
      color13 = "#cb92f2";

      # Cyan
      color6  = "#70b9cc";
      color14 = "#7fc8db";

      # White
      color7  = "#c4c4c4";
      color15 = "#cccccc";
    };

    keybindings = {
      "ctrl+shift+w" = "no_op";
    };
  };

  xdg.desktopEntries = lib.mkIf (!isDarwin) {
    kitty = {
      name = "kitty";
      genericName = "Terminal Emulator";
      comment = "Fast, feature-rich, GPU based terminal";
      exec = "nixGLIntel kitty %u";
      icon = "kitty";
      categories = [ "System" "TerminalEmulator" ];
      terminal = false;
    };
  };
}
