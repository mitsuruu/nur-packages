{ pkgs ? import <nixpkgs> { } }:
{
  # The `lib`, `modules`, and `overlays` names are special
  # lib = import ./lib { inherit pkgs; }; # functions
  # modules = import ./modules; # NixOS modules
  # overlays = import ./overlays; # nixpkgs overlays
  citra-canary = (pkgs.callPackage ./pkgs/citra { }).canary;
  citra-nightly = (pkgs.callPackage ./pkgs/citra { }).nightly;
  flight-core = pkgs.callPackage ./pkgs/flight-core { };
  gmm = pkgs.callPackage ./pkgs/gmm { };
  macos-cursors = pkgs.callPackage ./pkgs/macOS-cursors { };
  pixel-perfect-svg = pkgs.callPackage ./pkgs/pixel-perfect-svg { };
  rose-pine-sddm = pkgs.callPackage ./pkgs/rose-pine-sddm { };
  sunshine-git = pkgs.callPackage ./pkgs/sunshine-git { };
  tokyo-night-gtk-icons = pkgs.callPackage ./pkgs/tokyo-night-gtk-icons { };
  tokyo-night-sddm = pkgs.callPackage ./pkgs/tokyo-night-sddm { };
  totk-optimizer = pkgs.callPackage ./pkgs/totk-optimizer { };
  viper = pkgs.callPackage ./pkgs/viper { };
  wheelwizard = pkgs.callPackage ./pkgs/wheelwizard { };

  # Patched packages
  gamescope-no-fast-math = pkgs.gamescope.overrideAttrs (_: {
    NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
  });
}
