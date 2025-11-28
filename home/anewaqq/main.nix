{ pkgs, ... }:

{
  imports = [
	./module/tools/git.nix
	./module/tools/root.nix

	#./module/shell/zsh.nix
  ];

  home.packages = with pkgs; [
    # Tools
    eza
    tmux
    bottom
    ripgrep
    bat
    joshuto

    # Bluetooth
    bluetuith

    # Git
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
