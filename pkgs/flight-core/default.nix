{ cargo-tauri
, dbus
, freetype
, gsettings-desktop-schemas
, libsoup_2_4
, openssl
, pkg-config
, rustPlatform
, webkitgtk_4_1
, wrapGAppsHook3
, buildNpmPackage
, fetchFromGitHub
,
}:

let
  pname = "FlightCore";
  version = "3.0.4";

  cargoHash = "sha256-JFpT+cqnFbkmPzYUygTEbuTg7LwTx2gR86i7FzAH54E=";
  npmDepsHash = "sha256-DzPuvgmpaPTUUbrSnAVbll5mqZRPAWqHGdmNtgtLtU4=";

  src = fetchFromGitHub {
    owner = "R2NorthstarTools";
    repo = "FlightCore";
    rev = "v${version}";
    hash = "sha256-rzBaZEnIaqxfyusVNTWU0qKggDnI1tSR7WN8HE6epWo=";
  };

  frontend-build = buildNpmPackage {
    pname = "flightcore-ui";
    inherit version src npmDepsHash;
    sourceRoot = "${src.name}/src-vue";

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

  # patches = [ ./remove-windows-requirement.patch ];

  # copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    substituteInPlace ./tauri.conf.json \
      --replace-fail '"frontendDist": "../src-vue/dist"' '"frontendDist": "dist"' \
      --replace-fail '"beforeBuildCommand": "cd src-vue && npm run build",' '"beforeBuildCommand": "",' \
      --replace-fail '"createUpdaterArtifacts": "v1Compatible",' '"createUpdaterArtifacts": false,'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    openssl
    freetype
    libsoup_2_4
    webkitgtk_4_1
    gsettings-desktop-schemas
  ];

  # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
  # postFixup = ''
  #   wrapProgram "$out/bin/gmm" \
  #     --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  # '';

  meta = {
    description = "Installer/Updater/Launcher for Northstar";
    homepage = "https://github.com/R2NorthstarTools/FlightCore";
    platforms = [ "x86_64-linux" ];
    # mainProgram = "gmm";
  };
}
