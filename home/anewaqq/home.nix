{ isDarwin ? false, ... }:

{
  home.username = "q";
  home.homeDirectory = if isDarwin then "/Users/q" else "/home/q";

  imports = [ ./main.nix ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
