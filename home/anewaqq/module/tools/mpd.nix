{ isDarwin, pkgs, ... }:

{
  services = {
    mpd = {
      enable = true;
      musicDirectory = if isDarwin then "~/Documents/Music/" else "~/files/media/Music/";
    };
    mpd-mpris.enable = !isDarwin;
  };

  home.packages = with pkgs; [
    rmpc
  ];
}
