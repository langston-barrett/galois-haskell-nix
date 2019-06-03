{ mkDerivation, aeson, base, bytestring, Cabal, directory, fetchgit
, filepath, fused-effects, hedgehog, hspec, process, split, stdenv
, template-haskell, text, unordered-containers
}:
mkDerivation {
  pname = "haskell-tree-sitter";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/tree-sitter/haskell-tree-sitter.git";
    sha256 = "15bfzkki28kjnl2va0g1jxa2pc09g5a5kfzh3hx32flw0brk68fy";
    rev = "b2ebfbf821b462e4d55350051a6d1f641c56078d";
    fetchSubmodules = false;
  };
  setupHaskellDepends = [ base Cabal directory process ];
  libraryHaskellDepends = [
    aeson base bytestring directory filepath fused-effects hedgehog
    split template-haskell text unordered-containers
  ];
  testHaskellDepends = [ base hedgehog hspec ];
  homepage = "http://github.com/tree-sitter/haskell-tree-sitter#readme";
  description = "haskell tree-sitter bindings";
  license = stdenv.lib.licenses.bsd3;
}
