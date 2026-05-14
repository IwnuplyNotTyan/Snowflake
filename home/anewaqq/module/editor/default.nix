{ pkgs, ... }:

{
  imports = [
    #./zed.nix # Zed
    ./emacs/emacs.nix # Emacs
    ./nvim.nix # Neovim
  ];

  home.packages = with pkgs; [
    # Go
    gopls

    # Nix
    nil
    nixd
  ];
}
