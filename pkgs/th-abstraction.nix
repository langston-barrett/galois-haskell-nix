{ mkDerivation, base, containers, fetchgit, ghc-prim, stdenv
, template-haskell
}:
mkDerivation {
  pname = "th-abstraction";
  version = "0.3.1.0";
  src = fetchgit {
    url = "https://github.com/glguy/th-abstraction";
    sha256 = "0z2rfv07h3xfsp45sqsh7ddhh26ph6qhwjlh2b10459k1pmpd7bw";
    rev = "855efbfdc0972094465492e1c862f760c068954d";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base containers ghc-prim template-haskell
  ];
  testHaskellDepends = [ base containers template-haskell ];
  homepage = "https://github.com/glguy/th-abstraction";
  description = "Nicer interface for reified information about data types";
  license = stdenv.lib.licenses.isc;
}
