{ pkgs, lib, cartridgePkg, ... }:

let
  emus = pkgs.buildEnv {
    name = "emus";
    paths = [ pkgs.retroarch ];
  };
  cartridge-wrapped = pkgs.symlinkJoin {
    name = "cartridge";
    paths = [ cartridgePkg ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/cartridge --prefix PATH : ${emus}/bin
    '';
  };
in {
  home.packages = [ cartridge-wrapped ];

  home.file.".config/cartridge/recipes/retroarch.json".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/IwnuplyNotTyan/Cartridge/refs/heads/main/_examples/retroarch.json";
    sha256 = "sha256-470b+yHn2xTkEgbvxoLYTfTlKRKesphMK2KFcBtPvQ8=";
  };
}