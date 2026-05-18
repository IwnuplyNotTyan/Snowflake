{
 #lib,
 #isDarwin,
 ...
}:

{
  programs.zed-editor.enable = true;
  home.file.".config/zed/themes/janleigh.json".source = ./zed.json;

  #xdg.desktopEntries = lib.mkIf (!isDarwin) {
  #  zeditor = {
  #    name = "Zed";
  #    genericName = "Text Editor";
  #    comment = "Text Editor";
  #    exec = "nixGLIntel zeditor %u";
  #    icon = "zed";
  #    categories = [
  #      "TextEditor"
  #      "Development"
  #    ];
  #    terminal = false;
  #  };
  #};
}
