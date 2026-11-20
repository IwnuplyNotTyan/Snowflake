{ lib
, python3Packages
, fetchFromGitHub
, fetchurl
, stdenv
, ...
}:

let
  pyobjc-framework-CoreMedia = python3Packages.buildPythonPackage {
    pname = "pyobjc-framework-CoreMedia";
    version = "11.1";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/1c/23/cafd29011d14eac27fc55770157ebb8e02ffed9f75e01f24e97616417c4c/pyobjc_framework_coremedia-11.1-cp313-cp313-macosx_10_13_universal2.whl";
      sha256 = "7ecdb64c743ffe9fd3949c7cc9109891b9f399a0852717fcb969d33c4e7ba527";
    };
    propagatedBuildInputs = with python3Packages; [
      pyobjc-core
      pyobjc-framework-Cocoa
    ];
    doCheck = false;
  };

  pyobjc-framework-CoreAudio = python3Packages.buildPythonPackage {
    pname = "pyobjc-framework-CoreAudio";
    version = "11.1";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/82/9b/24d03ace273585de2d04385f06b895ce92caf8f5af430b060618ebce9dbe/pyobjc_framework_coreaudio-11.1-cp313-cp313-macosx_10_13_universal2.whl";
      sha256 = "f73d996df1e721931d9f78050e1708735a173dbe3a76d9c71fb36e04f7208478";
    };
    propagatedBuildInputs = with python3Packages; [
      pyobjc-core
      pyobjc-framework-Cocoa
    ];
    doCheck = false;
  };

  pyobjc-framework-AVFoundation = python3Packages.buildPythonPackage {
    pname = "pyobjc-framework-AVFoundation";
    version = "11.1";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/3f/8c/b8ced7700b0e931dc37d14b05e2bead28d2598c887832b3d697da55b1845/pyobjc_framework_avfoundation-11.1-cp313-cp313-macosx_10_13_universal2.whl";
      sha256 = "e204d155a09c186601490e4402dcffb2845a5831079e389b47bd6a341fe5ee63";
    };
    propagatedBuildInputs = [
      python3Packages.pyobjc-core
      python3Packages.pyobjc-framework-Cocoa
      python3Packages.pyobjc-framework-Quartz
      pyobjc-framework-CoreAudio
      pyobjc-framework-CoreMedia
    ];
    doCheck = false;
  };

  pyobjc-framework-MediaPlayer = python3Packages.buildPythonPackage {
    pname = "pyobjc-framework-MediaPlayer";
    version = "11.1";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/2b/aa/b37aac80d821bd2fa347ddad1f6c7c75b23155e500edf1cb3b3740c27036/pyobjc_framework_mediaplayer-11.1-py2.py3-none-any.whl";
      sha256 = "b655cf537ea52d73209eb12935a047301c30239b318a366600f0f44335d51c9a";
    };
    propagatedBuildInputs = [
      python3Packages.pyobjc-core
      pyobjc-framework-AVFoundation
    ];
    doCheck = false;
  };
in

python3Packages.buildPythonApplication rec {
  pname = "mpd-now-playable";
  version = "1.6.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "00dani";
    repo = "mpd-now-playable";
    rev = "v${version}";
    hash = "sha256-JP7WkYV5fmbIdX2wwlfBDEcxdPFErlrX9URUb6eOZkU=";
  };

  env.PDM_BUILD_SCM_VERSION = version;

  nativeBuildInputs = with python3Packages; [
    pdm-backend
  ];

  propagatedBuildInputs = with python3Packages; [
    aiocache
    boltons
    mpd2
    ormsgpack
    pydantic
    pyobjc-framework-MediaPlayer
    pytomlpp
    rich
    xdg-base-dirs
    yarl
  ];

  doCheck = false;

  meta = with lib; {
    description = "Expose your MPD server as a 'now playable' app on macOS";
    homepage = "https://github.com/00dani/mpd-now-playable";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "mpd-now-playable";
  };
}
