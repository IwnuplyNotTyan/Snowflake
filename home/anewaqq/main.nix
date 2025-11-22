{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Tools
    eza

    # Git
    git
    github-cli

    # Editor
    neovim

    # Nixgl
    #nixgl.nixGLIntel
  ];
}
