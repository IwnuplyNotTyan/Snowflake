{ lib, isDarwin, ... }:

{
 imports = [
  ./kitty.nix   # Terminal
  ] ++ lib.optionals (!isDarwin) [
  ./i3.nix 	# WM
  ({ pkgs, lib, ... }: {
    _module.args.isSway = true;
  })
  #./sway.nix
  ./picom.nix	# Picom
  #./qs/qs.nix  # Widgets
  ./eww/eww.nix
  ]
  ++ lib.optionals (isDarwin) [
  #./neru.nix	# Neru
  #./miri.nix	# WM
  ./skhd.nix    # Hotkey's
 ];
}
