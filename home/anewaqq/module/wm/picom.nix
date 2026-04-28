{
  services.picom = {
    enable = true;

    # Backend & VSync
    backend = "glx";
    vSync = true;

    # Shadows
    shadow = false;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = 0.75;
    
    # Fading
    fade = true;
    fadeSteps = [ 0.05 0.05 ];

    # Corners
    settings = {
      corner-radius = 13;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];

      # General Settings
      dithered-present = false;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      unredir-if-possible = true;
      unredir-if-possible-delay = 200;
      detect-transient = true;
      use-damage = true;
      log-level = "warn";

      # Window type settings
      wintypes = {
        tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; full-shadow = false; };
        dock = { shadow = false; clip-shadow-above = true; };
        dnd = { shadow = false; };
        popup_menu = { opacity = 0.8; };
        dropdown_menu = { opacity = 0.8; };
      };
    };
  };
}
