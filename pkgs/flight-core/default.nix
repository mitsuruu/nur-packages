{
  appimageTools,
  lib,
  fetchurl,
  libthai,
  harfbuzz,
  fontconfig,
  freetype,
  libz,
  libX11,
  mesa,
  libdrm,
  fribidi,
  libxcb,
  libgpg-error,
  libGL,
}: let
  pname = "flight-core";
  version = "2.23.1";

  src = fetchurl {
    url = "https://github.com/R2NorthstarTools/FlightCore/releases/download/v${version}/${pname}_${version}_amd64.AppImage";
    hash = "sha256-fXq/biSGnTbJ3mr19kJNPzYIy/wLyyXlMhsdVLDjMQQ=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  libs = [
    libthai
    harfbuzz
    fontconfig
    freetype
    libz
    libX11
    mesa
    libdrm
    fribidi
    libxcb
    libgpg-error
    libGL
  ];
in
  appimageTools.wrapType2 {
    inherit pname version src;
    multiPkgs = null; # no 32bit needed
    extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ libs;
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    meta = {
      description = "Installer/Updater/Launcher for Northstar";
      homepage = "https://github.com/R2NorthstarTools/FlightCore";
      license = lib.licenses.mit;
      mainProgram = "flight-core";
      maintainers = with lib.maintainers; [NotAShelf];
      platforms = ["x86_64-linux"];
    };
  }