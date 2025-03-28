{ pkgs ? import <nixpkgs> { } }:
{
  # The `lib`, `modules`, and `overlays` names are special
  # lib = import ./lib { inherit pkgs; }; # functions
  # modules = import ./modules; # NixOS modules
  # overlays = import ./overlays; # nixpkgs overlays
  citra-canary = (pkgs.callPackage ./pkgs/citra { }).canary;
  citra-nightly = (pkgs.callPackage ./pkgs/citra { }).nightly;
  flight-core = pkgs.callPackage ./pkgs/flight-core { };
  macos-cursors = pkgs.callPackage ./pkgs/macOS-cursors { };
  perfect-dark-jpn = (pkgs.callPackage ./pkgs/perfect-dark { }).jpn;
  perfect-dark-ntsc = (pkgs.callPackage ./pkgs/perfect-dark { }).ntsc;
  perfect-dark-pal = (pkgs.callPackage ./pkgs/perfect-dark { }).pal;
  pixel-perfect-svg = pkgs.callPackage ./pkgs/pixel-perfect-svg { };
  rose-pine-sddm = pkgs.callPackage ./pkgs/rose-pine-sddm { };
  suyu = (pkgs.callPackage ./pkgs/suyu { }).suyu;
  suyu-appimage = (pkgs.callPackage ./pkgs/suyu { }).suyu-appimage;
  tokyo-night-gtk-icons = pkgs.callPackage ./pkgs/tokyo-night-gtk-icons { };
  tokyo-night-sddm = pkgs.callPackage ./pkgs/tokyo-night-sddm { };
  totk-optimizer = pkgs.callPackage ./pkgs/totk-optimizer { };
  viper = pkgs.callPackage ./pkgs/viper { };

  # Patched packages
  gamescope-no-fast-math = pkgs.gamescope.overrideAttrs (_: {
    NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
  });
}
