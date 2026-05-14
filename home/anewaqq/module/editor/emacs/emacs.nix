{ pkgs, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomDir = ./.;
    emacs = pkgs.emacs-pgtk;
  };
}
