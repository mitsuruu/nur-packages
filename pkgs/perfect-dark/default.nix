{ lib, stdenv, pkgs, fetchurl, autoPatchelfHook, makeDesktopItem, ... }:

let
  iconBaseUrl = "https://cdn2.steamgriddb.com/icon/64314c17210c549a854f1f1c7adce8b6/32/";

  icon256 = fetchurl {
    url = "${iconBaseUrl}256x256.png";
    hash = "sha256-ER5OCFENyrd7R4YCCHI/UldpUw6/zQjH7QniJOnEH/E=";
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
    mkdir -p $out/{bin,share/{applications/,icons/hicolor/scalable/apps/}}
    install -m755 -D pd $out/bin/pd
    install -m755 -D pd.pal $out/bin/pd.pal
    install -m755 -D pd.jpn $out/bin/pd.jpn
    cp "${ntscDesktopItem}/share/applications/pd.desktop" $out/share/applications/pd.desktop
    cp "${palDesktopItem}/share/applications/pd.pal.desktop" $out/share/applications/pd.pal.desktop
    cp "${jpnDesktopItem}/share/applications/pd.jpn.desktop" $out/share/applications/pd.jpn.desktop
    cp ${icon256} $out/share/icons/hicolor/scalable/apps/pd.png
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
