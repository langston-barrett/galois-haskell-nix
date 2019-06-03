{ mkDerivation, base, comonad, criterion, fetchgit, free, hspec
, hspec-core, HUnit, leancheck, recursion-schemes, stdenv
}:
mkDerivation {
  pname = "freer-cofreer";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/robrix/freer-cofreer.git";
    sha256 = "1zyym4y4gzycs4d8q5issf1hzl6pa196cv1nkq9psxlbwa7axpmm";
    rev = "dbb0c5a203b094303231a209e85b08a22c08673f";
    fetchSubmodules = false;
  };
  libraryHaskellDepends = [ base comonad free recursion-schemes ];
  testHaskellDepends = [ base hspec hspec-core HUnit leancheck ];
  benchmarkHaskellDepends = [ base criterion recursion-schemes ];
  homepage = "https://github.com/robrix/freer-cofreer#readme";
  description = "Freer monads and Cofreer comonads";
  license = stdenv.lib.licenses.bsd3;
}
