{ lib, stdenv, fetchurl, unzip, zlib, xorg, autoPatchelfHook }:
let
  version = "2.1.0";
  pname = "totk-optimizer";
  src = fetchurl {
    url = "https://github.com/MaxLastBreath/TOTK-mods/releases/download/manager-${version}/TOTK_Optimizer_${version}_Linux.zip";
    hash = "sha256-gHuW8TmdGAK64I1ETUFOpAFudF1Slytcx/nY0pS+/m0=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ zlib autoPatchelfHook unzip xorg.libxcb ];

  installPhase = ''
    mkdir -p $out/bin
    runHook preInstall
    ls
    install -m755 'TOTK Optimizer ${version}' $out/bin/totk-optimizer
    cp -r '_internal' $out/bin/
    runHook postInstall
  '';
}
