{ pkgs, isSway, isDarwin, lib, ...}:
{
  home.packages = with pkgs; [
    telegram-desktop
  ];


xdg.desktopEntries."org.telegram.desktop" = lib.mkIf (isSway || !isDarwin) {
  name = "Telegram Desktop";
  comment = "Official desktop client for the Telegram messaging app";
  exec = "env QT_QPA_PLATFORM=xcb Telegram -- %u";
  icon = "telegram";
  terminal = false;
  categories = [ "Network" "InstantMessaging" "Chat" ];
  mimeType = [ "x-scheme-handler/tg" ];
  settings = {
    X-GNOME-UsesNotifications = "true";
  };
};
}
