{
  pkgs,
  lib,
  isDarwin ? false,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      # Tools
      bottom
      #joshuto
      rmpc
      comma

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
