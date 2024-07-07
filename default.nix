{ pkgs ? import <nixpkgs> { } }:
{
  # The `lib`, `modules`, and `overlays` names are special
  # lib = import ./lib { inherit pkgs; }; # functions
  # modules = import ./modules; # NixOS modules
  # overlays = import ./overlays; # nixpkgs overlays

  macos-cursors = pkgs.callPackage ./pkgs/macOS-cursors { };
  tokyo-night-gtk-icons = pkgs.callPackage ./pkgs/tokyo-night-gtk-icons { };
  tokyo-night-sddm = pkgs.callPackage ./pkgs/tokyo-night-sddm { };

  suyu = (pkgs.callPackage ./pkgs/suyu { }).suyu;
  citra-canary = (pkgs.callPackage ./pkgs/citra { }).canary;
  citra-nightly = (pkgs.callPackage ./pkgs/citra { }).nightly;
  perfect-dark-ntsc = (pkgs.callPackage ./pkgs/perfect-dark { }).ntsc;
  perfect-dark-pal = (pkgs.callPackage ./pkgs/perfect-dark { }).pal;
  perfect-dark-jpn = (pkgs.callPackage ./pkgs/perfect-dark { }).jpn;
}
