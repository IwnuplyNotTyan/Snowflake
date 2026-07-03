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
      rmpc
      comma

      # SHH
      openssh

      # Shell
      ripgrep
      bat
      eza

      # Etc
      deadnix
      treefmt
      nodejs_22
      tetrigo
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
