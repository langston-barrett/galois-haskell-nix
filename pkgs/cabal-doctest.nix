{ mkDerivation, base, Cabal, directory, fetchgit, filepath, stdenv
}:
mkDerivation {
  pname = "cabal-doctest";
  version = "1.0.6";
  src = fetchgit {
    url = "https://github.com/phadej/cabal-doctest.git";
    sha256 = "0d2j7a6q1s3c6yxsqcgw5wshiqg70613kvzp1z63kc648az5p8la";
    rev = "7fe8327c43bb499cf9769ac45d926fd6eb860446";
    fetchSubmodules = true;
  };
  revision = "2";
  editedCabalFile = "1kbiwqm4fxrsdpcqijdq98h8wzmxydcvxd03f1z8dliqzyqsbd60";
  libraryHaskellDepends = [ base Cabal directory filepath ];
  homepage = "https://github.com/phadej/cabal-doctest";
  description = "A Setup.hs helper for doctests running";
  license = stdenv.lib.licenses.bsd3;
}
