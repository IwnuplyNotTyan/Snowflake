{ config, isDarwin, lib, pkgs, mpdNowPlayablePkg ? null, ... }:

let
  mpd-now-playable =
    if mpdNowPlayablePkg != null
    then mpdNowPlayablePkg
    else if isDarwin
    then pkgs.callPackage ../../../pkgs/mpd-now-playable { }
    else null;
in
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

  launchd.agents.mpd-now-playable = lib.mkIf isDarwin {
    enable = true;
    config = {
      ProgramArguments = [ "${mpd-now-playable}/bin/mpd-now-playable" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/mpd-now-playable.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/mpd-now-playable.error.log";
    };
  };

  home.packages = with pkgs; [
    rmpc
  ] ++ lib.optionals isDarwin [
    mpd-now-playable
  ];
}

