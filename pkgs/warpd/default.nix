{ lib, pkgs, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "warpd";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "warpd";
    rev = "v${version}";
    sha256 = "sha256-YHTQ5N4SZSa3S3sy/lNjarKPkANIuB2khwyOW5TW2vo=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    pkgs.apple-sdk
  ];

  makeFlags = [ "PLATFORM=macos" "PREFIX=$(out)" ];

  buildPhase = ''
    mkdir -p bin
    ${stdenv.cc}/bin/clang -o bin/warpd \
      -target x86_64-apple-macos \
      -Wl,-adhoc_codesign \
      src/*.c src/platform/macos/*.m \
      -framework Cocoa -framework Carbon \
      -Wno-deprecated-declarations \
      -Wno-unused-parameter \
      -std=c99 \
      -DVERSION=\"${version}\"
  '';

  postPatch = ''
    sed -i 's/^size_t nr_boxes;/extern size_t nr_boxes;/' src/platform/macos/macos.h
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/warpd $out/bin/warpd
  '';

  meta = {
    description = "A modal keyboard-driven interface for mouse manipulation";
    homepage = "https://github.com/rvaiya/warpd";
    platforms = lib.platforms.darwin;
  };
}
