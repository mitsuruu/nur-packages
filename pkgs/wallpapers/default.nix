{ lib, stdenv, ... }:
stdenv.mkDerivation {
  pname = "wallpapers";
  version = "1.0.0";

  src = ../../files/wallpapers;

  installPhase = ''
    mkdir -p $out/share/wallpapers
    cp * $out/share/wallpapers
  '';

  meta = with lib; {
    description = "Wallpapers";
    homepage = "https://github.com/yamamech/fuyu";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
