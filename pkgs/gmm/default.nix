{ cargo-tauri_1
, dbus
, freetype
, gsettings-desktop-schemas
, libsoup_2_4
, openssl
, pkg-config
, rustPlatform
, webkitgtk_4_0
, wrapGAppsHook3
, buildNpmPackage
, fetchFromGitHub
,
}:

let
  pname = "gmm";
  version = "2.5.3";

  cargoHash = "sha256-ke32gJeVMh43YqSMJ++QX4evwZVTlXHzRvHPPug1x0g=";
  npmDepsHash = "sha256-DtzHXsyudEXhD8+4FV8rw1DWmowlPxj3Bo+Xg/DaPJw=";

  src = fetchFromGitHub {
    owner = "Eidenz";
    repo = "GMM";
    rev = "db13cd657558c5f7b5dec185aced00dd87e9675c";
    hash = "sha256-pEuM9y7+UKtqqmq4qE6z5iwFEUGfgA3LrRuVKQrOQPU=";
  };

  frontend-build = buildNpmPackage {
    pname = "gmm-ui";
    inherit version src npmDepsHash;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r dist/** $out/dist

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit version pname src cargoHash;
  sourceRoot = "${src.name}/src-tauri";

  preConfigure = ''
    mkdir -p dist
    cp -R ${frontend-build}/dist/** dist
  '';

  patches = [ ./remove-windows-requirement.patch ];

  # copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    substituteInPlace ./tauri.conf.json \
      --replace-fail '"targets": ["msi", "updater"],' '"targets": ["msi", "updater", "deb"],' \
      --replace-fail '"distDir": "../dist",' '"distDir": "dist",' \
      --replace-fail '"beforeBuildCommand": "npm run build",' '"beforeBuildCommand": "",'
  '';

  nativeBuildInputs = [
    cargo-tauri_1.hook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    openssl
    freetype
    libsoup_2_4
    webkitgtk_4_0
    gsettings-desktop-schemas
  ];

  # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
  postFixup = ''
    wrapProgram "$out/bin/gmm" \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = {
    description = "A Tauri Genshin & ZZZ Mod Manager";
    homepage = "https://github.com/Eidenz/GMM";
    platforms = [ "x86_64-linux" ];
    mainProgram = "gmm";
  };
}
