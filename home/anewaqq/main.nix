{ pkgs, pkgsUnstable, lib, ... }:

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
    diffnav
    #gh-dash
    #pkgsUnstable.gh-enhance

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
    pkgsUnstable.atuin

    # Etc
    devenv
    deadnix
    treefmt
    chatterino7
    nodejs_22
    unrar

    # Book's
    zathura

    # Games
    #gale

    # Video's?
    #kdePackages.kdenlive
    #audacity

    # Nixgl
    nixgl.nixGLIntel
  ];
  
  #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #      "crush"
  #];
  
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "unrar"
  ];
}
