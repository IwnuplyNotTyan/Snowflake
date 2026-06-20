{ isDarwin, ... }:

{
  #home.packages = lib.mkIf isDarwin [
  #  pkgs.syncthing-macos
  #];

  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      gui = {
        user = if isDarwin then "Anewaqq-mac" else "Eweless3";
      };
      devices = {
        "Merlinx" = { id = "GMY525L-2WMZECJ-BVQDSXN-PCZGT2W-LTGXOG2-6AJJKKP-GQWKATJ-X7BYPAZ"; };
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
