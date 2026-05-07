{ lib, isDarwin, ... }:

{
 imports = [
  ./kitty.nix   # Terminal
  ] ++ lib.optionals (!isDarwin) [
  ./i3.nix 	# WM
  ./picom.nix	# Picom
  ./qs/qs.nix   # Widgets
  ]
  ++ lib.optionals (isDarwin) [
  #./neru.nix	# Neru
  ./miri.nix	# WM
 ];
}
