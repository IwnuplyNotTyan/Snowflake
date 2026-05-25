{ pkgs, lib, warpdPkg, isDarwin ? false, ... }:

let
  keyboardSwitcher = pkgs.runCommand "keyboardSwitcher" {} ''
    mkdir -p $out/bin
    cp ${./keyboardSwitcher} $out/bin/keyboardSwitcher
    chmod +x $out/bin/keyboardSwitcher
  '';
in
{
  services.skhd = lib.mkIf isDarwin {
    enable = true;
    config = ''
      cmd + alt - x : ${keyboardSwitcher}/bin/keyboardSwitcher select "U.S." 2>/dev/null; ${warpdPkg}/bin/warpd --hint
    '';
  };
}
