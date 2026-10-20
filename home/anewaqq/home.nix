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
    ./pkgs.nix 			 		# Basic app's
    #./module/ai.nix 		 		# AI (Opencode, ollama and etc)
    ./module/git.nix 		 		# Git(hub)
    ./module/nix.nix 		 		# Nix
    ./module/ssh 		 		# SSH
    ./module/shell/tmux.nix			# tmux
    ./module/shell/zsh.nix			# Zsh 
    ./module/shell/starship.nix			# Starship
    ./module/editor 		 		# Text editor
    ./module/editor/idea.nix			# Idea
    ./module/tools/syncthing.nix 		# Syncthing
    ./module/tools/mpd.nix 	 		# Music
    ./module/tools/zathura.nix   		# Zathura
    ./module/tools/direnv.nix    		# DirEnv
    ./module/tools/koi.nix       		# Markdown suck
    ./module/tools/mousewalk.nix 		# DVD Cursor!
    ./module/media/telegram.nix  		# Telegram Desktop
    ./module/wm/kitty.nix   	 		# Only Kitty
    ./module/wm/warpd.nix    	 		# Warpd

    ({ pkgs, lib, ... }: {       		# Wayland*
      _module.args.isSway = false;
    })
  ] ++ lib.optionals (!isDarwin) [
    # *(Non)Nixos
    ./module/wm/i3.nix	 			# I3WM
    #./module/wm/niri.nix			# Niri
    #./module/wm/sway.nix			# SwayWM
    ./module/wm/theme.nix			# Like a default gtk theme 
    ./module/wm/picom.nix			# Picom
    ./module/wm/eww/eww.nix			# Widgets
    ./module/wm/wal.nix				# Wallpapers picker
    ./module/wm/vicinae.nix			# Vicinae

    ./module/tools/cartridge.nix    # Emu wrapper, no darwin btw many emu's cant be builded in mac intel
  #]
  #++ lib.optionals (isDarwin) [
    # *MacOS
    #./module/wm/miri.nix   	 		# Miri WM
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
  home.enableNixpkgsReleaseCheck = false;
}
