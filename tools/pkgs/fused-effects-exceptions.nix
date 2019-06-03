{ mkDerivation, base, fetchgit, fused-effects, safe-exceptions
, stdenv, unliftio-core
}:
mkDerivation {
  pname = "fused-effects-exceptions";
  version = "0.1.1.0";
  src = fetchgit {
    url = "https://github.com/fused-effects/fused-effects-exceptions.git";
    sha256 = "1j6gag5iv52kviq4bw1cfy3himphdhl5cb7ildhbgwhsgqwajlvz";
    rev = "5533982d404e614fa411adf817c32d85fefe9958";
    fetchSubmodules = false;
  };
  libraryHaskellDepends = [
    base fused-effects safe-exceptions unliftio-core
  ];
  homepage = "https://github.com/patrickt/fused-effects-exceptions#readme";
  description = "Handle exceptions thrown in IO with fused-effects";
  license = stdenv.lib.licenses.bsd3;
}
