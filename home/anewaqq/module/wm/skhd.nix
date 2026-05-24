{ pkgs, lib, isDarwin ? false, ... }:

let
  keyboardSwitcher = pkgs.runCommand "keyboardSwitcher" {} ''
    mkdir -p $out/bin
    cp ${./keyboardSwitcher} $out/bin/keyboardSwitcher
    chmod +x $out/bin/keyboardSwitcher
  '';

  warpd = pkgs.runCommand "warpd" {} ''
    mkdir -p $out/bin
    cp ${./warpd} $out/bin/warpd
    chmod +x $out/bin/warpd
  '';
in
{
  services.skhd = lib.mkIf isDarwin {
    enable = true;
    config = ''
      cmd + alt - x : ${keyboardSwitcher}/bin/keyboardSwitcher select "U.S." 2>/dev/null; ${warpd}/bin/warpd --hint
    '';
  };
}
