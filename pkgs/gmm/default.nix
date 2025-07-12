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
  version = "3.0.1";

  cargoHash = "sha256-GleoL9468DAWM2vGot8OkzTq9XG8ONwp6NkQAEHuMbQ=";
  npmDepsHash = "sha256-cyvElztqmcOFHy5m2aQI3F7D6461Yn0m/OVeZmw79lk=";

  src = fetchFromGitHub {
    owner = "Eidenz";
    repo = "GMM";
    rev = "a028c675aeb1bc2732b1b28df2c1c08acaa12dc1";
    hash = "sha256-pPU+2G0VNQTlrokPivAXSeicszSJuvOi7CIYDchtftA=";
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
