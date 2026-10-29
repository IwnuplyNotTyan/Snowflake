{ pkgs, lib, cartridge, isDarwin, ... }:

let
  emus = pkgs.buildEnv {
    name = "emus";
    paths = [ pkgs.retroarch ];
  };
  cartridge-wrapped = pkgs.symlinkJoin {
    name = "cartridge";
    paths = [ cartridge.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/cartridge --prefix PATH : ${emus}/bin
    '';
  };
in {
  imports = [ cartridge.homeModules.default ];

  programs.cartridge = {
    enable = true;
    package = cartridge-wrapped;
    romDir = "~/Documents/games";
    lang = "en"; showArt = true;
    openApps = isDarwin;

    steam = {
      autoAdd = true;
      prefix = "Cartridge";
      iconsProvider = "steamgriddb";
    };
  };

  home.file.".config/cartridge/recipes/retroarch.json".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/IwnuplyNotTyan/Cartridge/refs/heads/main/_examples/retroarch.json";
    sha256 = "sha256-470b+yHn2xTkEgbvxoLYTfTlKRKesphMK2KFcBtPvQ8=";
  };
}
