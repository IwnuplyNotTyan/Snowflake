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

    # SHH
    openssh

    # Nixgl
    #nixgl.nixGLIntel
  ];
}
