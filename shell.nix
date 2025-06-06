{ pkgs ? import <nixpkgs> { }
, shellHook ? ""
, buildInputs ? [ pkgs.nil pkgs.nixpkgs-fmt pkgs.nushell pkgs.nix-update ]
}:
pkgs.mkShell {
  inherit shellHook;
  buildInputs = buildInputs;
}
