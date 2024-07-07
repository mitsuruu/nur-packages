{ pkgs, makeScopeWithSplicing', generateSplicesForMkScope }:

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "perfectDarkPackages";
  f = self: pkgs // {
    ntsc = self.callPackage ./generic.nix { region = "ntsc"; };
    pal = self.callPackage ./generic.nix { region = "pal"; };
    jpn = self.callPackage ./generic.nix { region = "jpn"; };
  };
}