{ pkgs ? import <nixpkgs> { }
, shellHook ? ""
, buildInputs ? [ pkgs.nil pkgs.nixpkgs-fmt ]
}:
pkgs.mkShell {
  inherit shellHook;
  buildInputs = buildInputs;
}
