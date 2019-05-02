{ mkDerivation, base, Cabal, deepseq, fetchgit, QuickCheck, stdenv
}:
mkDerivation {
  pname = "dlist";
  version = "0.8.0.6";
  src = fetchgit {
    url = "https://github.com/spl/dlist";
    sha256 = "110hg84x977dnr9bvgfg5b7cq8pv8ds167lzhjs0mwfmjjmah3v5";
    rev = "c9b157297c9df2879725eddfed9512525091300a";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [ base deepseq ];
  testHaskellDepends = [ base Cabal QuickCheck ];
  homepage = "https://github.com/spl/dlist";
  description = "Difference lists";
  license = stdenv.lib.licenses.bsd3;
}
