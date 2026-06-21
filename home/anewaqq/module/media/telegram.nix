{ pkgs, ...}:
{
  home.packages = with pkgs; [
    telegram-desktop
  ];

  #xdg.desktopEntries = lib.mkIf (!isDarwin) {
  #  telegram-desktop = {
  #    name = "Telegram Desktop";
  #    comment = "Official Telegram messaging app";
  #    exec = "nixGLIntel ${pkgs.telegram-desktop}/bin/telegram-desktop %u";
  #    icon = "telegram";
  #    terminal = false;
  #    categories = [ "Network" "InstantMessaging" ];
  #    mimeType = [ "x-scheme-handler/tg" ];
  #    #startupWMClass = "TelegramDesktop";
  #    #startupNotify = true;
  #    settings = {
  #      X-GNOME-UsesNotifications = "true";
  #    };
  #  };
  #};
}
