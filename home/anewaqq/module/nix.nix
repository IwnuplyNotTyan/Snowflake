{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnsupportedSystem = true;
      allowBroken = true;
      allowUnfree = true;
    };
  };

  nix = { 
  package = pkgs.nix;
  settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
 };
}
