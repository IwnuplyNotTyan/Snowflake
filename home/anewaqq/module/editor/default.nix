{ pkgs, ... }:

{
 imports = [
  ./zed.nix # Zed
 ];

 home.packages = with pkgs; [
  # Go
  gopls

  # Nix
  nil
 ];
}
