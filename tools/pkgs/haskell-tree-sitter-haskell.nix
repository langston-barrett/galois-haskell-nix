{ mkDerivation, base, fetchgit, haskell-tree-sitter, stdenv }:
mkDerivation {
  pname = "tree-sitter-haskell";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/tree-sitter/haskell-tree-sitter.git";
    sha256 = "15bfzkki28kjnl2va0g1jxa2pc09g5a5kfzh3hx32flw0brk68fy";
    rev = "b2ebfbf821b462e4d55350051a6d1f641c56078d";
    fetchSubmodules = false;
  };
  postUnpack = "sourceRoot+=/languages/haskell; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base haskell-tree-sitter ];
  homepage = "https://github.com/tree-sitter/tree-sitter-haskell#readme";
  description = "tree-sitter haskell language bindings";
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
