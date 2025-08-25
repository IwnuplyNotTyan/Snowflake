{ pkgs, ... }:

{
  home.username = "q";
  home.homeDirectory = "/home/q";

  home.packages = with pkgs; [
    # Tools
    git

    # Nixgl
    #nixgl.nixGLIntel
  ];

  programs.bash.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
