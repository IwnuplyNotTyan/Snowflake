{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: { qutebrowser = prev.qutebrowser.override { enableWideVine = true; }; })
  ];

  home.packages = with pkgs; [
    qutebrowser
  ];
}
