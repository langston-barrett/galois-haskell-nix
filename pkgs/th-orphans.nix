{ mkDerivation, base, bytestring, fetchgit, ghc-prim, hspec
, hspec-discover, mtl, stdenv, template-haskell, th-lift
, th-lift-instances, th-reify-many
}:
mkDerivation {
  pname = "th-orphans";
  version = "0.13.7";
  src = fetchgit {
    url = "https://github.com/mgsloan/th-orphans.git";
    sha256 = "0h7qi489a4rqfq1m390mbl8b71bhh7av8zybvc4avh8yg5xqzvzb";
    rev = "e9f9b32f1ff0afa08fbc56047dcccd8b20c9c4cd";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base mtl template-haskell th-lift th-lift-instances th-reify-many
  ];
  testHaskellDepends = [
    base bytestring ghc-prim hspec template-haskell th-lift
  ];
  testToolDepends = [ hspec-discover ];
  description = "Orphan instances for TH datatypes";
  license = stdenv.lib.licenses.bsd3;
}
