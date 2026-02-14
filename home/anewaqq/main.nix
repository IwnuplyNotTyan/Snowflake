{ pkgs, ... }:

{
  imports = [
	./module/git
	./module/ssh
	#./module/shell/zsh.nix
  ];

  home.packages = with pkgs; [
    # Tools
    tmux
    bottom
    #joshuto
    bluetuith
    rmpc

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
    ripgrep
    bat
    zoxide
    eza

    # Etc
    devenv
    deadnix
    treefmt

    # Book's
    zathura

    # Games
    #gale

    # Video's?
    kdePackages.kdenlive
    #audacity

    # Nixgl
    nixgl.nixGLIntel
  ];
}
