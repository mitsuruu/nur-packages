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
  version = "2.6.1";

  cargoHash = "sha256-xg6EUw/DeYvhbJ6hY7HCqK5mqu1Zl91dG8U+YTxLUx8=";
  npmDepsHash = "sha256-wts07hmn2rVfhfKj11ZVRdOE6LtraO5jw9yeyDBEYa4=";

  src = fetchFromGitHub {
    owner = "Eidenz";
    repo = "GMM";
    rev = "181a52d21e9e7196bc0d51ed72dfa4fbdfdcc4fb";
    hash = "sha256-Mk3Tg0R53GJ94judFNAoSyEZVWO8PMauSyniiahv+m4=";
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
