{
  lib,
  isDarwin ? false,
  ...
}:

{
  home.username = "q";
  home.homeDirectory = if isDarwin then "/Users/q" else "/home/q";

  imports = [
    # Some cfg's
    ./pkgs.nix # Basic app's
    ./module/git.nix # Git(hub)
    ./module/ssh # SSH
    ./module/shell # Starship & zsh
    ./module/editor # Text editor
    ./module/tools/zathura.nix # Zathura
    ./module/nix.nix # Nix
  ]
  ++ lib.optionals (!isDarwin) [
    # *(Non)Nixos
    ./module/wm # I3 & Kitty
  ]
  ++ lib.optionals (isDarwin) [
    # *MacOS
    ./module/wm/kitty.nix # *Only Kitty
    ./module/wm/miri.nix   # *Miri WM
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
