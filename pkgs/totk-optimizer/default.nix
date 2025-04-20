{ appimageTools
, lib
, fetchurl
, libthai
, harfbuzz
, fontconfig
, freetype
, libz
, libX11
, mesa
, libdrm
, fribidi
, libxcb
, libgpg-error
, libGL
,
}:
let
  version = "3.1.6";
  pname = "totk-optimizer";
  src = fetchurl {
    url = "https://github.com/MaxLastBreath/nx-optimizer/releases/download/manager-${version}/NX.Optimizer.${version}.AppImage";
    hash = "sha256-Eq3gGntj9tI9VWLl9QXcueIN1e0LFj9TuIKy3BagBys=";
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
}
