{ miriPkg, ... }:

{
  programs.miri = {
    enable = true;
    package = miriPkg;
    launchAtLogin = true;
    settings = {
      animationDurationMs = 50;
      outerGap = 5;
      rules = [
       {
         app_name = "Emacs";
         behavior = "tile";
	}
      ];
    };
  };
}
