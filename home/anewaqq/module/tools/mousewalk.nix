{ mousewalkPkg, lib, isDarwin, ... }:

{
  home.packages = [ mousewalkPkg ];

  xdg.desktopEntries = lib.mkIf (!isDarwin) {
    mousewalk = {
      name = "mousewalk";
      genericName = "Mousewalk";
      comment = "Mouse cursor screensaver";
      exec = "mousewalk %u";
      icon = "mousewalk";
      categories = [
        "Utility"
      ];
      terminal = false;
    };
  };
}
