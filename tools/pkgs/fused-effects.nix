{ mkDerivation, base, criterion, deepseq, doctest, fetchgit, hspec
, inspection-testing, MonadRandom, QuickCheck, random, stdenv
, transformers, unliftio-core
}:
mkDerivation {
  pname = "fused-effects";
  version = "0.4.0.0";
  src = fetchgit {
    url = "https://github.com/fused-effects/fused-effects.git";
    sha256 = "1xwmm6lnqm722qg09834qag7vilqyjhfgfm4zpl4nxaxkfsz0ahz";
    rev = "bb2ebd2b15d943fdaa8edea1d90b03285f22f7bd";
    fetchSubmodules = false;
  };
  libraryHaskellDepends = [
    base deepseq MonadRandom random transformers unliftio-core
  ];
  testHaskellDepends = [
    base doctest hspec inspection-testing QuickCheck transformers
  ];
  benchmarkHaskellDepends = [ base criterion ];
  homepage = "https://github.com/fused-effects/fused-effects";
  description = "A fast, flexible, fused effect system";
  license = stdenv.lib.licenses.bsd3;
}
