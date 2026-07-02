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
    ./pkgs.nix 			 # Basic app's
    ./module/ai.nix 		 # AI (Opencode, ollama and etc)
    ./module/git.nix 		 # Git(hub)
    ./module/ssh 		 # SSH
    ./module/tools/syncthing.nix # Syncthing
    ./module/shell 		 # Starship & zsh
    ./module/editor 		 # Text editor
    ./module/tools/mpd.nix 	 # Music
    ./module/tools/zathura.nix   # Zathura
    ./module/nix.nix 		 # Nix
    ./module/tools/direnv.nix    # DirEnv
    ./module/tools/koi.nix       # Markdown suck
    ./module/tools/mousewalk.nix # DVD Cursor!
    ./module/media/telegram.nix  # Telegram Desktop
  ]
  ++ lib.optionals (!isDarwin) [
    # *(Non)Nixos
    ./module/wm			 # I3 & Kitty
  ]
  ++ lib.optionals (isDarwin) [
    # *MacOS
    ./module/wm/skhd.nix    	# *Hotkeys
    ./module/wm/kitty.nix   	# *Only Kitty
    #./module/wm/miri.nix   	# *Miri WM
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
