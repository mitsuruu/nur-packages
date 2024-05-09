{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlays` names are special
  # lib = import ./lib { inherit pkgs; }; # functions
  # modules = import ./modules; # NixOS modules
  # overlays = import ./overlays; # nixpkgs overlays

  macos-cursors = pkgs.callPackage ./pkgs/macOS-cursors { };
  suyu = pkgs.callPackage ./pkgs/suyu { };
  tokyo-night-gtk-icons = pkgs.callPackage ./pkgs/tokyo-night-gtk-icons { };
  tokyo-night-sddm = pkgs.callPackage ./pkgs/tokyo-night-sddm { };
  wallpapers = pkgs.callPackage ./pkgs/wallpapers { };
}
