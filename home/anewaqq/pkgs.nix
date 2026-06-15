{
  pkgs,
  pkgsUnstable,
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
      chatterino7
      nodejs_22
      tetrigo
      buku
      pkgsUnstable.gamescope
    ]
    ++ lib.optionals (!isDarwin) [
      nixgl.nixGLIntel
      nixgl.nixVulkanIntel
      bluetuith
    ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "unrar"
    ];
}
