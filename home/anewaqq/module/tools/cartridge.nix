{ pkgs, lib, cartridgePkg, isDarwin, imports, ... }:

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
  programs.cartridge = {
    package = cartridge-wrapped;
    romDir = "~/Documents/games";
    lang = "en";
    showArt = true;
    openApps = isDarwin;

    steam = {
      autoAdd = true;
      prefix = "Cartridge";
      icons_provider = "steamgriddb";
    };
  };

  home.file.".config/cartridge/recipes/retroarch.json".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/IwnuplyNotTyan/Cartridge/refs/heads/main/_examples/retroarch.json";
    sha256 = "sha256-470b+yHn2xTkEgbvxoLYTfTlKRKesphMK2KFcBtPvQ8=";
  };
}