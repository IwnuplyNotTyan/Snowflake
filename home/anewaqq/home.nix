{ pkgs, ... }:

{
  home.username = "q";
  home.homeDirectory = "/home/q";
 
  imports = [ ./main.nix ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
