{
  lib,
  pkgs,
  isDarwin,
  ...
}:

{
  programs.zathura = {
    enable = true;
    options = {
      selection-notification = true;
      selection-clipboard = "clipboard";
      guioptions = "sv";
      scroll-page-aware = true;
      statusbar-home-tilde = true;
      recolor = true;
      adjust-open = "width";
      statusbar-h-padding = 10;
      statusbar-v-padding = 10;
      font = "Iosevka Nerd Font 17";

      default-fg = "#c5c8c9";
      default-bg = "#0B0F10";
      completion-bg = "#0B0F10";
      completion-fg = "#c5c8c9";
      completion-highlight-bg = "#0B0F10";
      completion-highlight-fg = "#c5c8c9";
      completion-group-bg = "#0B0F10";
      completion-group-fg = "#c5c8c9";
      statusbar-fg = "#c5c8c9";
      statusbar-bg = "#0B0F10";
      notification-bg = "#0B0F10";
      notification-fg = "#c5c8c9";
      notification-error-bg = "#0B0F10";
      notification-error-fg = "#c5c8c9";
      notification-warning-bg = "#0B0F10";
      notification-warning-fg = "#c5c8c9";
      inputbar-fg = "#c5c8c9";
      inputbar-bg = "#0B0F10";
      recolor-lightcolor = "#0B0F10";
      recolor-darkcolor = "#c5c8c9";
      index-fg = "#c5c8c9";
      index-bg = "#0B0F10";
      index-active-fg = "#c5c8c9";
      index-active-bg = "#0B0F10";
      render-loading-bg = "#0B0F10";
      render-loading-fg = "#c5c8c9";
      highlight-color = "#0B0F10";
      highlight-fg = "#c5c8c9";
      highlight-active-color = "#0B0F10";
    };
  };

  xdg.desktopEntries = lib.mkIf (!isDarwin) {
    zathura = {
      name = "zathura";
      genericName = "Document Viewer";
      comment = "A highly customizable document viewer";
      exec = "nixGLIntel zathura %u";
      icon = "zathura";
      categories = [
        "Office"
        "Viewer"
      ];
      terminal = false;
    };
  };

home.file."Applications/Zathura.app/Contents/Info.plist".text = lib.mkIf isDarwin ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleExecutable</key>
      <string>zathura</string>
      <key>CFBundleName</key>
      <string>Zathura</string>
      <key>CFBundleDisplayName</key>
      <string>Zathura</string>
      <key>CFBundleIdentifier</key>
      <string>org.pwmt.zathura</string>
      <key>CFBundleVersion</key>
      <string>1.0</string>
      <key>CFBundlePackageType</key>
      <string>APPL</string>
      <key>LSMinimumSystemVersion</key>
      <string>10.13</string>
      <key>NSHighResolutionCapable</key>
      <true/>
    </dict>
    </plist>
  '';

home.file."Applications/Zathura.app/Contents/MacOS/zathura".source = lib.mkIf isDarwin (
  pkgs.writeShellScript "zathura" ''
    exec ${pkgs.zathura}/bin/zathura "$@"
  ''
);
}
