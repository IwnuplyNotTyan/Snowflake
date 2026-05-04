{ lib
, stdenv
}:

stdenv.mkDerivation {
  pname = "miri";
  version = "0-unstable-2025-05-04";

  src = ./miri;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/miri
    chmod +x $out/bin/miri
  '';

  meta = {
    description = "Niri-ish, keyboard-first window manager for macOS";
    homepage = "https://github.com/maria-rcks/miri";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "miri";
  };
}
