{ lib, isDarwin, ... }:

{
 imports = [
  ./kitty.nix   # Terminal
  ] ++ lib.optionals (!isDarwin) [
  ./i3.nix 	# WM
  ./picom.nix	# Picom
  ]
  ++ lib.optionals (isDarwin) [
  #./neru.nix	# Neru
  ./miri.nix	# WM
 ];
}
