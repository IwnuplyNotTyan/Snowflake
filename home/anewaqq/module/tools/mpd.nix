{ isDarwin, lib, pkgs, ... }:

{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "~/Documents/Music/";
      #musicDirectory = if isDarwin then "~/Documents/Music/" else "~/files/media/Music/";
      extraConfig = lib.mkIf isDarwin ''
        audio_output {
          type "osx"
          name "CoreAudio"
          device "Headphones (eqMac)"
          mixer_type "software"
        }
      '';
    };
    mpd-mpris.enable = !isDarwin;
  };

  home.packages = with pkgs; [
    rmpc
  ];
}
