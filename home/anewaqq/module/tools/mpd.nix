{ isDarwin, pkgs, ... }:

{
  services = {
    mpd = {
      enable = !isDarwin;
      musicDirectory = if isDarwin then "~/Documents/Music/" else "~/files/media/Music/";
    };
    mpd-mpris.enable = !isDarwin;
  };

  home.packages = with pkgs; [
    rmpc
  ];
}
