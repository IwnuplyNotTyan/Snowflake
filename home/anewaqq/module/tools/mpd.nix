{ isDarwin, lib, pkgs, ... }:

{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "~/Documents/Music/";
      #musicDirectory = if isDarwin then "~/Documents/Music/" else "~/files/media/Music/";
    };
    mpd-mpris.enable = !isDarwin;
  };

  home.packages = with pkgs; [
    rmpc
  ];
}
