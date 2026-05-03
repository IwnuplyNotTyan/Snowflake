{
  pkgs,
  pkgsUnstable,
  lib,
  isDarwin ? false,
  ...
}:

{
  imports = [
    # Some cfg's
    ./module/git.nix # Git(hub)
    ./module/ssh # SSH
    ./module/shell # Starship & zsh
  ]
  ++ lib.optionals (!isDarwin) [
    # (Non)Nixos
    ./module/wm # I3 & Kitty
  ]
  ++ lib.optionals (isDarwin) [
    # MacOS
    ./module/wm/kitty.nix # Only Kitty
  ];

  home.packages =
    with pkgs;
    [
      # Tools
      bottom
      #joshuto
      rmpc
      comma

      # Editor
      neovim

      # Fonts
      nerd-fonts.iosevka

      # SHH
      openssh

      # Shell
      ripgrep
      bat
      eza

      # Etc
      devenv
      deadnix
      treefmt
      chatterino7
      nodejs_22
      unrar

    ]
    ++ lib.optionals (!isDarwin) [
      nixgl.nixGLIntel
      bluetuith
    ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "unrar"
    ];
}
