{ isDarwin, ... }:

{
  #home.packages = lib.mkIf isDarwin [
  #  pkgs.syncthing-macos
  #];

  services.syncthing = {
    enable = true;
    settings = {
      gui = {
        user = if isDarwin then "Anewaqq-mac" else "Eweless3";
      };
      devices = {
        "Merlinx" = { id = "L7CUYJH-7I7TYV3-3BAD5I7-35OTRR2-G6ZBNRP-DOAET6G-Y5CATHI-EU4B5QB"; };
      };
      folders = {
        "Camera" = {
          path = if isDarwin then "~/Documents/Camera" else "~/files/Camera";
          devices = [ "Merlinx" ];
        };
        "Music" = {
          path = if isDarwin then "~/Documents/Music" else "~/files/media/Music";
          devices = [ "Merlinx" ];
        };
        "Wallpapers" = {
          path = if isDarwin then "~/Documents/Wal" else "~/files/media/wal";
          devices = [ "Merlinx" ];
        };
      };
    };
  };
}
