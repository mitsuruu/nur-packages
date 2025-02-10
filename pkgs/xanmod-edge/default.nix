{ pkgs
, linuxKernel
, buildPackages
, callPackage
, lib
}:
with linuxKernel;
rec {
  xanmodKernels = callPackage ./xanmod-kernels.nix;
  linux_xanmod_edge = xanmodKernels {
    variant = "edge";
    kernelPatches = with linuxKernel.kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];
  };
}
