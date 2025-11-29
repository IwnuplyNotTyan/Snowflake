{
  description = "Nyxt Browser";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      pname = "nyxt";
      version = "4.0.0-pre-release-13";
      
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        inherit pname version;
        
        src = pkgs.fetchurl {
          url = "https://github.com/atlas-engineer/nyxt/releases/download/${version}/Linux-Nyxt-x86_64.tar.gz";
          sha256 = "sha256-9kwgLVvnqXJnL/8jdY2jly/bS2XtgF9WBsDeoXNHX8M=";
        };
        
        nativeBuildInputs = with pkgs; [ 
          makeWrapper
          autoPatchelfHook
        ];
        
        buildInputs = with pkgs; [
          stdenv.cc.cc.lib
          enchant2
          webkitgtk_4_1
          glib
          gtk3
          gsettings-desktop-schemas
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          sqlite
          libffi
          openssl
          zlib
          nss
          nspr
        ];
        
        dontStrip = true;  # Не трогаем бинарник
        
        unpackPhase = ''
          runHook preUnpack
          
          tar xzf $src
          
          # Находим и извлекаем AppImage
          appimage=$(find . -name "*.AppImage" -type f | head -n 1)
          chmod +x "$appimage"
          "$appimage" --appimage-extract
          
          cd squashfs-root
          
          runHook postUnpack
        '';
        
        installPhase = ''
          runHook preInstall
          
          mkdir -p $out/share/nyxt $out/bin
          
          # Копируем всё содержимое
          cp -r . $out/share/nyxt/
          
          # Ищем возможные пути для SBCL
          sbcl_dirs=""
          for dir in usr/lib usr/lib/sbcl lib lib/sbcl .; do
            if [ -d "$out/share/nyxt/$dir" ]; then
              sbcl_dirs="$out/share/nyxt/$dir:$sbcl_dirs"
            fi
          done
          
          # Создаём wrapper
          makeWrapper $out/share/nyxt/usr/bin/nyxt $out/bin/nyxt \
            --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [
              pkgs.enchant2
              pkgs.webkitgtk_4_1
              pkgs.glib
              pkgs.gtk3
              pkgs.gsettings-desktop-schemas
              pkgs.gst_all_1.gstreamer
              pkgs.gst_all_1.gst-plugins-base
              pkgs.gst_all_1.gst-plugins-good
              pkgs.gst_all_1.gst-plugins-bad
              pkgs.sqlite
              pkgs.libffi
              pkgs.openssl
              pkgs.nss
              pkgs.nspr
            ]} \
            --set APPDIR $out/share/nyxt \
            --set SBCL_HOME "$out/share/nyxt/usr/lib" \
            --prefix PATH : "$out/share/nyxt/usr/bin" \
            --chdir "$out/share/nyxt"
          
          # Desktop файл
          if [ -f $out/share/nyxt/nyxt.desktop ]; then
            mkdir -p $out/share/applications
            cp $out/share/nyxt/nyxt.desktop $out/share/applications/
            substituteInPlace $out/share/applications/nyxt.desktop \
              --replace 'Exec=AppRun' 'Exec=nyxt' \
              --replace 'Icon=nyxt' "Icon=$out/share/nyxt/nyxt.png"
          fi
          
          # Иконка
          if [ -f $out/share/nyxt/nyxt.png ]; then
            mkdir -p $out/share/icons/hicolor/512x512/apps
            cp $out/share/nyxt/nyxt.png $out/share/icons/hicolor/512x512/apps/
          fi
          
          runHook postInstall
        '';
        
        meta = with pkgs.lib; {
          description = "Nyxt web browser";
          homepage = "https://nyxt.atlas.engineer/";
          platforms = [ "x86_64-linux" ];
        };
      };
    };
}
