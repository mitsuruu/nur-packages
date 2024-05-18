{ pkgs, kdePackages, fetchFromGitHub }:
kdePackages.callPackage ./generic.nix rec {
  pname = "citra-nightly";
  version = "2088";
  branch = "nightly";

  # Fetched from https://api.citra-emu.org/gamedb
  # Please make sure to update this when updating citra!
  compat-list = pkgs.callPackage ./compat-list.nix { };

  src = fetchFromGitHub {
    owner = "PabloMK7";
    repo = "citra";
    rev = "480604ec72433f8cde3a8f6d22d3f8c86bea402f";
    sha256 = "0l9w4i0zbafcv2s6pd1zqb11vh0i7gzwbqnzlz9al6ihwbsgbj3k";
    fetchSubmodules = false; # We do fetch these but must substitute mirror URLs beforehand
    leaveDotGit = true;

    # We must use mirrors because upstream yuzu got nuked.
    # Sadly, the regular nix-prefetch-git doesn't support changing submodule urls.
    # This substitutes mirrors and fetches the submodules manually.
    postFetch = ''
      pushd $out
      # Git won't allow working on submodules otherwise...
      git restore --staged .

      cp .gitmodules{,.bak}

      substituteInPlace .gitmodules \
        --replace-fail yuzu-emu yuzu-emu-mirror \
        --replace-fail citra-emu PabloMK7 \
        --replace-fail merryhime yuzu-mirror \

      git submodule update --init --recursive -j ''${NIX_BUILD_CORES:-1} --progress --depth 1 --checkout --force

      mv .gitmodules{.bak,}

      # Remove .git dirs
      find . -name .git -type f -exec rm -rf {} +
      rm -rf .git/
      popd
    '';
  };
}
