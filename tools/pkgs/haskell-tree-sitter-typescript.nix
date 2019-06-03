{ mkDerivation, base, fetchgit, haskell-tree-sitter, stdenv }:
mkDerivation {
  pname = "tree-sitter-typescript";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/tree-sitter/haskell-tree-sitter.git";
    sha256 = "15bfzkki28kjnl2va0g1jxa2pc09g5a5kfzh3hx32flw0brk68fy";
    rev = "b2ebfbf821b462e4d55350051a6d1f641c56078d";
    fetchSubmodules = false;
  };
  postUnpack = "sourceRoot+=/languages/typescript; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base haskell-tree-sitter ];
  homepage = "https://github.com/tree-sitter/tree-sitter-typescript#readme";
  description = "tree-sitter typescript language bindings";
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
