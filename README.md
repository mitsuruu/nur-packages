# Nur-packages

![Build Status](https://github.com/mitsuruu/nur-packages/workflows/Build%20and%20populate%20cache/badge.svg)
[![Cachix Cache](https://img.shields.io/badge/cachix-mitsuruu-blue.svg)](https://mitsuruu.cachix.org)

My personal [NUR](https://github.com/nix-community/NUR) repository.

It provides a pre-compiled binary cache for NixOS unstable.
To use it add the following line to your nix.conf

See a full list of Flake outputs with `nix flake show github:mitsuruu/nur-packages`.

## Install & Configure

It's recommended to set up [Cachix](https://app.cachix.org/cache/mitsuruu) so you don't have to build packages (most useful for the gaming-related packages).
```nix
# configuration.nix
{
  nix.settings = {
    substituters = ["https://mitsuruu.cachix.org"];
    trusted-public-keys = ["mitsuruu.cachix.org-1:c09hKovw2iXEEFzfoUhA5mzEEiGIF/N4wP5vxEyLD40="];
  };
}
```
