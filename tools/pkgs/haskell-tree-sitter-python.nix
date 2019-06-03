{ mkDerivation, aeson, base, directory, fetchgit, filepath
, haskell-tree-sitter, stdenv, template-haskell
}:
mkDerivation {
  pname = "tree-sitter-python";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/tree-sitter/haskell-tree-sitter.git";
    sha256 = "15bfzkki28kjnl2va0g1jxa2pc09g5a5kfzh3hx32flw0brk68fy";
    rev = "b2ebfbf821b462e4d55350051a6d1f641c56078d";
    fetchSubmodules = false;
  };
  postUnpack = "sourceRoot+=/languages/python; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base directory filepath haskell-tree-sitter template-haskell
  ];
  homepage = "https://github.com/tree-sitter/tree-sitter-python#readme";
  description = "tree-sitter python language bindings";
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
