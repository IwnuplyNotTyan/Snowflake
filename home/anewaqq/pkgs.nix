{
  pkgs,
  lib,
  koiPkg,
  isDarwin ? false,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      # Tools
      bottom
      rmpc
      comma
      koiPkg

      # SHH
      openssh

      # Shell
      ripgrep
      bat
      eza

      # Etc
      deadnix
      treefmt
      chatterino7
      nodejs_22
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
