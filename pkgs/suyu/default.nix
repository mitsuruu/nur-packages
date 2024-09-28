{ package ? "suyu", kdePackages, makeScopeWithSplicing', generateSplicesForMkScope }:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "suyuPackages";
  f = self: kdePackages // {
    compat-list = self.callPackage ./compat-list.nix { };
    nx_tzdb = self.callPackage ./nx_tzdb.nix { };

    suyu = self.callPackage ./suyu.nix { };
    suyu-appimage = self.callPackage ./appimage.nix { };
  };
}
