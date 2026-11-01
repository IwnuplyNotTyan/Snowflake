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
        "Merlinx" = { id = "U6CIKQG-IBSDTIE-IUIVJYO-I77CSTM-AVCSI5P-RZHE7HI-337AHZB-D2WLCQI"; };
      };
      folders = {
        "Camera" = {
          #path = if isDarwin then "~/Documents/Camera" else "~/files/Camera";
          path = "~/Documents/Camera";
	  devices = [ "Merlinx" ];
        };
	"Pics" = {
	  #path = if isDarwin then "~/Documents/Pics" else "~/files/media/Pics";
	  path = "~/Documents/Pics";
	  devices = [ "Merlinx" ];
	};
        "Music" = {
          #path = if isDarwin then "~/Documents/Music" else "~/files/media/Music";
          path = "~/Documents/Music";
	  devices = [ "Merlinx" ];
        };
        #"Wallpapers" = {
        #  path = if isDarwin then "~/Documents/Wal" else "~/files/media/wal";
        #  devices = [ "Merlinx" ];
        #};
	"Aegis" = {
	  #path = if isDarwin then "~/Documents/Aegis" else "~/files/aegis";
	  path = "~/Documents/Aegis";
	  devices = [ "Merlinx" ];
	};
      };
    };
  };
}
