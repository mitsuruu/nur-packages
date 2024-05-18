{ package ? "suyu", kdePackages, makeScopeWithSplicing', generateSplicesForMkScope }:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "citraPackages";
  f = self: kdePackages // {
    compat-list = self.callPackage ./compat-list.nix { };
    canary = self.callPackage ./canary.nix { };
    nightly = self.callPackage ./nightly.nix { };
  };
}
