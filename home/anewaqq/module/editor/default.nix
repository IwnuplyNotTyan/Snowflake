{ pkgs, ... }:

{
  imports = [
    ./zed.nix # Zed
    ./nvim.nix # Neovim
  ];

  home.packages = with pkgs; [
    # Go
    gopls

    # Nix
    nil
  ];
}
