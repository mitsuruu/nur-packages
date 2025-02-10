{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };
  outputs = { self, nixpkgs, git-hooks }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      checks = forAllSystems (system: {
        pre-commit-check = git-hooks.lib.${system}.run {
          src = ./.;
          hooks.nixpkgs-fmt.enable = true;
        };
      });

      devShell = forAllSystems (system: import ./shell.nix {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        pkgs = import nixpkgs { inherit system; };
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      });

      legacyPackages = forAllSystems (system: import ./default.nix {
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      });

      packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});

      overlay = forAllSystems (system: (final: prev: import ./default.nix {
        pkgs = prev;
      }));
    };
}
