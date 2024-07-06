{ lib, stdenv, pkgs, fetchurl, autoPatchelfHook, makeDesktopItem, ... }:

let
  iconBaseUrl = "https://cdn2.steamgriddb.com/icon/64314c17210c549a854f1f1c7adce8b6/32/";

  icon256 = fetchurl {
    url = "${iconBaseUrl}256x256.png";
    hash = "sha256-ER5OCFENyrd7R4YCCHI/UldpUw6/zQjH7QniJOnEH/E=";
  };

  icon64 = fetchurl {
    url = "${iconBaseUrl}64x64.png";
    hash = "sha256-7VlgfshbDqRtKjrbPM34EXphU0oyZCc6xUl61M8dbXc=";
  };

  icon48 = fetchurl {
    url = "${iconBaseUrl}48x48.png";
    hash = "sha256-Wu3NClRVgeXiYO8/69guTbBgR2+MCZ4N73snTt6MpCE=";
  };

  icon32 = fetchurl {
    url = "${iconBaseUrl}32x32.png";
    hash = "sha256-TKeEOppic9W5GPulBMutjMavwej0jlxsKwaWB9nL9X4=";
  };

  icon24 = fetchurl {
    url = "${iconBaseUrl}24x24.png";
    hash = "sha256-Xn0BIGKM+cxQH0Epo+kPe3S+fT2yiNPE6p5aeJAHe1I=";
  };

  icon16 = fetchurl {
    url = "${iconBaseUrl}16x16.png";
    hash = "sha256-HmjwEzabJvJnPHNzeNS96fay9KpIRCAy5h9iBZHKEbk=";
  };

  ntscDesktopItem = makeDesktopItem {
    name = "pd";
    desktopName = "Perfect Dark (NTSC)";
    comment = "work in progress port of n64decomp/perfect_dark to modern platforms";
    genericName = "First-person shooter";
    categories = [ "Game" ];
    exec = "pd";
    icon = "pd";
  };

  palDesktopItem = makeDesktopItem {
    name = "pd.pal";
    desktopName = "Perfect Dark (PAL)";
    comment = "work in progress port of n64decomp/perfect_dark to modern platforms";
    genericName = "First-person shooter";
    categories = [ "Game" ];
    exec = "pd.pal";
    icon = "pd";
  };

  jpnDesktopItem = makeDesktopItem {
    name = "pd.jpn";
    desktopName = "Perfect Dark (JPN)";
    comment = "work in progress port of n64decomp/perfect_dark to modern platforms";
    genericName = "First-person shooter";
    categories = [ "Game" ];
    exec = "pd.jpn";
    icon = "pd";
  };
in 
pkgs.pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "perfect-dark";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/fgsfdsfgs/perfect_dark/releases/download/ci-dev-build/pd-i686-linux.tar.gz";
    hash = "sha256-7nkWfcXOsWt2qO4QkYMiqaPIULimhOgqoWsvsLvSrAo=";
  };

  buildInputs = with pkgs.pkgsi686Linux; [
    SDL2
  ];

  nativeBuildInputs = with pkgs.pkgsi686Linux; [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/{applications/,icons/hicolor/{256x256/apps,64x64/apps,48x48/apps,32x32/apps,24x24/apps,16x16/apps}}}
    install -m755 -D pd $out/bin/pd
    install -m755 -D pd.pal $out/bin/pd.pal
    install -m755 -D pd.jpn $out/bin/pd.jpn
    cp "${ntscDesktopItem}/share/applications/pd.desktop" $out/share/applications/pd.desktop
    cp "${palDesktopItem}/share/applications/pd.pal.desktop" $out/share/applications/pd.pal.desktop
    cp "${jpnDesktopItem}/share/applications/pd.jpn.desktop" $out/share/applications/pd.jpn.desktop
    cp ${icon256} $out/share/icons/hicolor/256x256/apps/pd.png
    cp ${icon64} $out/share/icons/hicolor/64x64/apps/pd.png
    cp ${icon48} $out/share/icons/hicolor/48x48/apps/pd.png
    cp ${icon32} $out/share/icons/hicolor/32x32/apps/pd.png
    cp ${icon24} $out/share/icons/hicolor/24x24/apps/pd.png
    cp ${icon16} $out/share/icons/hicolor/16x16/apps/pd.png
    runHook postInstall
  '';

  desktopItems = [
    ntscDesktopItem
    palDesktopItem
    jpnDesktopItem
  ];

  meta = with lib; {
    description = "work in progress port of n64decomp/perfect_dark to modern platforms";
    homepage = "https://github.com/fgsfdsfgs/perfect_dark";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
