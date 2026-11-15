{ isDarwin, lib, pkgs, ... }:

{
  services = {
    mpd = {
      enable = !isDarwin;
      musicDirectory = "~/Documents/Music/";
      #musicDirectory = if isDarwin then "~/Documents/Music/" else "~/files/media/Music/";
    };
    mpd-mpris.enable = !isDarwin;
  };

  home.packages = lib.mkIf (!isDarwin) (with pkgs; [
    rmpc
  ]);
}
