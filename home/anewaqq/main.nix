{ pkgs, ... }:

{
  imports = [
	./module/tools/git.nix
  ];

  home.packages = with pkgs; [
    # Tools
    eza
    tmux

    # Bluetooth
    bluetuith

    # Git
    gitMinimal
    git-lfs
    lazygit
    github-cli

    # Editor
    neovim

    # SHH
    openssh

    # Shell
    zsh
    starship

    # Nixgl
    #nixgl.nixGLIntel
  ];
}
