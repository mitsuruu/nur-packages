{ pkgs ? import <nixpkgs> { } }:
{
  # The `lib`, `modules`, and `overlays` names are special
  # lib = import ./lib { inherit pkgs; }; # functions
  # modules = import ./modules; # NixOS modules
  # overlays = import ./overlays; # nixpkgs overlays
  eden = pkgs.callPackage ./pkgs/eden { };
  flight-core = pkgs.callPackage ./pkgs/flight-core { };
  gmm = pkgs.callPackage ./pkgs/gmm { };
  pixel-perfect-svg = pkgs.callPackage ./pkgs/pixel-perfect-svg { };
  sunshine-git = pkgs.callPackage ./pkgs/sunshine-git { };
  totk-optimizer = pkgs.callPackage ./pkgs/totk-optimizer { };
  viper = pkgs.callPackage ./pkgs/viper { };
  wheelwizard = pkgs.callPackage ./pkgs/wheelwizard { };

  # Patched packages
  gamescope-no-fast-math = pkgs.gamescope.overrideAttrs (_: {
    NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
  });
}
