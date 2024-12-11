{ appimageTools, fetchurl }:
let
  version = "v0.0.3";
  pname = "suyu";
  src = fetchurl {
    url = "https://git.suyu.dev/suyu/suyu/releases/download/${version}/Suyu-Linux_x86_64.AppImage";
    hash = "sha256-26sWhTvB6K1i/K3fmwYg5pDIUi+7xs3dz8yVj5q7H0c=";
  };

  appimageContents = appimageTools.extractType1 { inherit pname version src; };
in
appimageTools.wrapType1 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/dev.suyu_emu.suyu.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/dev.suyu_emu.suyu.desktop \
      --replace-fail 'Exec=suyu %f' 'Exec=${pname} %f'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    homepage = "https://suyu-emu.org";
    changelog = "https://suyu-emu.org/entry";
    description = "An experimental Nintendo Switch emulator written in C++";
    longDescription = ''
      An experimental Nintendo Switch emulator written in C++.
      Using the mainline branch is recommended for general usage.
      Using the early-access branch is recommended if you would like to try out experimental features, with a cost of stability.
    '';
    mainProgram = "suyu";
    platforms = [ "x86_64-linux" ];
  };
}
