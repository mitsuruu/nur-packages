{ lib, libsForQt5, stdenvNoCC, fetchFromGitHub, pkgs }:
stdenvNoCC.mkDerivation {
  pname = "tokyo-night-sddm";
  version = "1..0";
  src = fetchFromGitHub {
    owner = "rototrash";
    repo = "tokyo-night-sddm";
    rev = "320c8e74ade1e94f640708eee0b9a75a395697c6";
    sha256 = "sha256-JRVVzyefqR2L3UrEK2iWyhUKfPMUNUnfRZmwdz05wL0=";
  };
  nativeBuildInputs = [
    libsForQt5.qt5.wrapQtAppsHook
    pkgs.wallpapers
  ];

  propagatedUserEnvPkgs = [
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
  ];

  buildPhase = ''
    runHook preBuild

    ln -s ${pkgs.wallpapers}/share/wallpapers/* Backgrounds/
    sed -i 's@Background="Backgrounds/win11.png"@Background="Backgrounds/anime-beach.jpg"@g' theme.conf

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR . $out/share/sddm/themes/tokyo-night-sddm
  '';

  meta = with lib; {
    description = "An SDDM theme based on the Tokyo Night colour palette.";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
  };
}
