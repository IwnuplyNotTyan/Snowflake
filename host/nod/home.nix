{ pkgs, ... }:

{
  home.username = "nix-on-droid";
  home.homeDirectory = "/data/data/com.termux.nix/files/home";

  imports = [ ../../home/anewaqq/main.nix ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
