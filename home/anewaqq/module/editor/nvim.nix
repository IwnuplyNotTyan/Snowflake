{ pkgs, waqq, ... }:

{
  home.packages = with pkgs; [ neovim ];

  xdg.configFile."nvim" = {
    source = waqq;
    recursive = true;
  };
}
