{ lib, buildNpmPackage, fetchFromGitHub }:
buildNpmPackage rec {
  pname = "pixel-perfect-svg";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kagof";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UyffmoMVaBF74wnJR8DC3iWUAzzGzrrMoAl5kNEolDo=";
  };

  npmDepsHash = "sha256-YKHxq1JJqZzdFo33OhSsOk5cYbA0c+N9XT4dD844O3U=";

  npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";
}
