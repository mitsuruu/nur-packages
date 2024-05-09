{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlays` names are special
  # lib = import ./lib { inherit pkgs; }; # functions
  # modules = import ./modules; # NixOS modules
  # overlays = import ./overlays; # nixpkgs overlays

  suyu = pkgs.callPackage ./pkgs/suyu { };
  macos-cursors = pkgs.callPackage ./pkgs/macOS-cursors { };
}
