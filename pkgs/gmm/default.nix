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
  version = "2.5.4";

  cargoHash = "sha256-QxM3fgIR/9mJ8IPPx38FBL8U4+ThiiibglSOfVQzxtE=";
  npmDepsHash = "sha256-10lTC7nmBUSB2bwcS7YrnpvHhsCtF7HeA9MUgI/2AnM=";

  src = fetchFromGitHub {
    owner = "Eidenz";
    repo = "GMM";
    rev = "761e40dd01b5f288715e0c2b6e9344de7fc0f3b7";
    hash = "sha256-uavdBG9HemLImqyMcwoHSeEK4ZAf6JLTjbJF39olMG8=";
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
