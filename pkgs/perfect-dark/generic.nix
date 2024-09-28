{ region, lib, stdenv, pkgs, fetchurl, autoPatchelfHook, makeDesktopItem, ... }:

let
  icon256 = fetchurl {
    url = "https://cdn2.steamgriddb.com/icon/64314c17210c549a854f1f1c7adce8b6/32/256x256.png";
    hash = "sha256-ER5OCFENyrd7R4YCCHI/UldpUw6/zQjH7QniJOnEH/E=";
  };

  desktopItem = makeDesktopItem {
    name = "pd";
    desktopName = "Perfect Dark (${lib.toUpper region})";
    comment = "work in progress port of n64decomp/perfect_dark to modern platforms";
    genericName = "First-person shooter";
    categories = [ "Game" ];
    exec = "pd";
    icon = "perfect-dark";
  };
in
pkgs.pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "perfect-dark";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/fgsfdsfgs/perfect_dark/releases/download/ci-dev-build/pd-i686-linux.tar.gz";
    hash = "sha256-/fh0yyHk91Ey7C7ZZjJkLgZoeKa6Uq38D6LEhwn/2eA=";
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
    install -m755 -D pd${if lib.hasPrefix region "ntsc" then "" else ".${region}"} $out/bin/pd
    cp "${desktopItem}/share/applications/pd.desktop" $out/share/applications/pd.desktop
    cp ${icon256} $out/share/icons/hicolor/scalable/apps/perfect-dark.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "work in progress port of n64decomp/perfect_dark to modern platforms";
    homepage = "https://github.com/fgsfdsfgs/perfect_dark";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
