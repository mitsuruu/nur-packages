{ pkgs
, autoconf
, boost
, catch2_3
, cmake
, cpp-jwt
, cubeb
, discord-rpc
, enet
, fetchgit
, fmt
, glslang
, lib
, libopus
, libusb1
, libva
, lz4
, nix-update-script
, nlohmann_json
, nv-codec-headers-12
, pkg-config
, qtbase
, qtmultimedia
, qttools
, qtwayland
, qtwebengine
, SDL2
, stdenv
, vulkan-headers
, vulkan-loader
, wrapQtAppsHook
, yasm
, zlib
, zstd
}:
let
  lib = pkgs.lib;
  nx_tzdb = pkgs.callPackage ./nx_tzdb.nix { };
  pname = "suyu";
  version = "latest";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchgit {
    url = "https://git.suyu.dev/suyu/suyu";
    rev = "dfb9f06e5c46f251e4208adf1d4861e85b1d5eea";
    fetchSubmodules = true;
    deepClone = true;
    sha256 = "sha256-50qCB0BnBhFuTjrI1xp20joYDOBs48uFi9Wg0313GpY=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    glslang
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    # vulkan-headers must come first, so the older propagated versions
    # don't get picked up by accident
    vulkan-headers

    boost
    catch2_3
    cpp-jwt
    cubeb
    discord-rpc
    # intentionally omitted: dynarmic - prefer vendored version for compatibility
    enet

    # vendored ffmpeg deps
    autoconf
    yasm
    libva # for accelerated video decode on non-nvidia
    nv-codec-headers-12 # for accelerated video decode on nvidia
    # end vendored ffmpeg deps

    fmt
    # intentionally omitted: gamemode - loaded dynamically at runtime
    # intentionally omitted: httplib - upstream requires an older version than what we have
    libopus
    libusb1
    # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
    lz4
    nlohmann_json
    qtbase
    qtmultimedia
    qtwayland
    qtwebengine
    # intentionally omitted: renderdoc - heavy, developer only
    SDL2
    # not packaged in nixpkgs: simpleini
    # intentionally omitted: stb - header only libraries, vendor uses git snapshot
    # not packaged in nixpkgs: vulkan-memory-allocator
    # intentionally omitted: xbyak - prefer vendored version for compatibility
    zlib
    zstd
  ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  cmakeFlags = [
    # actually has a noticeable performance impact
    "-DSUYUENABLE_LTO=ON"

    # build with qt6
    "-DENABLE_QT6=ON"
    "-DENABLE_QT_TRANSLATION=ON"

    # use system libraries
    # NB: "external" here means "from the externals/ directory in the source",
    # so "off" means "use system"
    "-DSUYUUSE_EXTERNAL_SDL2=OFF"
    "-DSUYUUSE_EXTERNAL_VULKAN_HEADERS=OFF"

    # don't use system ffmpeg, suyu uses internal APIs
    "-DSUYUUSE_BUNDLED_FFMPEG=ON"

    # don't check for missing submodules
    "-DSUYUCHECK_SUBMODULES=OFF"

    # enable some optional features
    "-DSUYUUSE_QT_WEB_ENGINE=ON"
    "-DSUYUUSE_QT_MULTIMEDIA=ON"
    "-DUSE_DISCORD_PRESENCE=ON"

    # We dont want to bother upstream with potentially outdated compat reports
    "-DSUYUENABLE_COMPATIBILITY_REPORTING=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
  ];

  # Does some handrolled SIMD
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";

  # Fixes vulkan detection.
  # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  preConfigure = ''
    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=${pname} | ${version} (nixpkgs) {}"
      "-DTITLE_BAR_FORMAT_RUNNING=${pname} | ${version} (nixpkgs) | {}"
    )

    # provide pre-downloaded tz data
    mkdir -p build/externals/nx_tzdb
    ln -s ${nx_tzdb} build/externals/nx_tzdb/nx_tzdb
  '';

  postInstall = ''
    install -Dm444 $src/dist/72-suyu-input.rules $out/lib/udev/rules.d/72-suyu-input.rules
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "mainline-0-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://suyu.dev";
    changelog = "https://suyu.dev/blog";
    description = "An experimental Nintendo Switch emulator written in C++";
    longDescription = ''
      An experimental Nintendo Switch emulator written in C++.
      Using the master/ branch is recommended for general usage.
      Using the dev branch is recommended if you would like to try out experimental features, with a cost of stability.
    '';
    mainProgram = "suyu";
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    license = with licenses; [
      gpl3Plus
      # Icons
      asl20
      mit
      cc0
    ];
    maintainers = with maintainers; [
      ashley
      ivar
      joshuafern
      sbruder
      k900
    ];
  };
}
