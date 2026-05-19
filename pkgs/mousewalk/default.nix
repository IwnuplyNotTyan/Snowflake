{ lib
, python3Packages
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, stdenv
, ...
}:

let
  desktopItem = makeDesktopItem {
    name = "mousewalk";
    exec = "mousewalk";
    icon = "mousewalk";
    desktopName = "Mousewalk";
    comment = "Mouse cursor screensaver";
    categories = [ "Utility" ];
    keywords = [ "screensaver" "mouse" "cursor" ];
    startupNotify = false;
  };
pynput-darwin-fixed = python3Packages.pynput.overridePythonAttrs (oldAttrs: {
    dontCheckRuntimeDeps = true;
    propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ lib.optionals stdenv.isDarwin [
      python3Packages.pyobjc-framework-Quartz
      python3Packages.pyobjc-framework-applicationservices
    ];
  });
in

python3Packages.buildPythonApplication {
  pname = "mousewalk";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "Catalyst-42";
    repo = "Mousewalk";
    rev = "v1.0.0";
    hash = "sha256-ejJWdZTSHZSOqBGqKCCbmfH1gxXnFqNNQZQXgS0Ts+o=";
  };
  format = "other";

  nativeBuildInputs = [ copyDesktopItems ];

  propagatedBuildInputs = with python3Packages; [
    pynput-darwin-fixed
    tkinter
  ];

  desktopItems = lib.optionals (!stdenv.isDarwin) [ desktopItem ];

  postInstall = ''
    mkdir -p $out/bin
    echo "#!/usr/bin/env python3" > $out/bin/mousewalk
    cat mousewalk.py >> $out/bin/mousewalk
    chmod +x $out/bin/mousewalk

    if [ ! -d "$out/share/applications" ]; then
      if [ -f "icons/mousewalk.png" ]; then
        mkdir -p $out/share/icons/hicolor/256x256/apps
        cp icons/mousewalk.png $out/share/icons/hicolor/256x256/apps/mousewalk.png
      fi
    fi
  '' + lib.optionalString stdenv.isDarwin ''
    APP_DIR="$out/Applications/Mousewalk.app/Contents"
    mkdir -p "$APP_DIR/MacOS"
    mkdir -p "$APP_DIR/Resources"

    ln -s $out/bin/mousewalk "$APP_DIR/MacOS/Mousewalk"

    cat <<EOF > "$APP_DIR/Info.plist"
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>English</string>
        <key>CFBundleExecutable</key>
        <string>Mousewalk</string>
        <key>CFBundleIconFile</key>
        <string>icon.icns</string>
        <key>CFBundleIdentifier</key>
        <string>org.catalyst42.mousewalk</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>Mousewalk</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleSignature</key>
        <string>????</string>
    </dict>
    </plist>
    EOF

    if [ -f "icons/icon.icns" ]; then
      cp icons/icon.icns "$APP_DIR/Resources/icon.icns"
    fi
  '';

  meta = with lib; {
    description = "Mouse cursor screensaver";
    homepage = "https://github.com/Catalyst-42/Mousewalk";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
