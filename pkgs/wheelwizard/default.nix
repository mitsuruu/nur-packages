{ lib
, fetchFromGitHub
, buildDotnetModule
, copyDesktopItems
, makeDesktopItem
}:

buildDotnetModule rec {
  pname = "wheelwizard";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "TeamWheelWizard";
    repo = "WheelWizard";
    rev = "2.2.1";
    hash = "sha256-Fw/Tj3HVZL1ttH/6eL8G9ZXs74hx+Ec1BOvT0FOicBU=";
  };

  projectFile = "WheelWizard/WheelWizard.csproj";
  nugetDeps = ./deps.json;

  # I'm not sure why, but csharpier makes it impossible to build the project.
  # > Version 0.30.6 of package csharpier is not found in NuGet feeds
  # It's possible that it's a build-time requirement, but this works for the time being.
  patches = [ ./remove-csharpier.patch ];

  nativeBuildInputs = [ copyDesktopItems ];

  postInstall = ''
    mkdir -p $out/share/pixmaps
    cp Flatpak/io.github.TeamWheelWizard.WheelWizard.png $out/share/pixmaps/wheelwizard.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "WheelWizard";
      exec = "WheelWizard";
      icon = "wheelwizard";
      desktopName = "WheelWizard";
      comment = meta.description;
      categories = [ "Game" ];
      startupWMClass = "WheelWizard";
      genericName = "Mario Kart Wii Mod Manager";
    })
  ];

  meta = with lib; {
    description = "Mario Kart Wii Mod Manager & Retro Rewind Auto Updater";
    homepage = "https://github.com/TeamWheelWizard/WheelWizard";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "WheelWizard";
  };
}
