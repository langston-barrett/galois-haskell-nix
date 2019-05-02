{ mkDerivation, array, base, bytestring, bytestring-handle
, containers, criterion, deepseq, directory, fetchgit, filepath
, QuickCheck, stdenv, tasty, tasty-quickcheck, time
}:
mkDerivation {
  pname = "tar";
  version = "0.6.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/tar";
    sha256 = "1p9z661nfhm845ssfymcr7b7wjs5y10wl9j8kp8r35f6lyf671z2";
    rev = "0653906be339a9329951e88e312585290177cc30";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    array base bytestring containers deepseq directory filepath time
  ];
  testHaskellDepends = [
    array base bytestring bytestring-handle containers deepseq
    directory filepath QuickCheck tasty tasty-quickcheck time
  ];
  benchmarkHaskellDepends = [
    array base bytestring containers criterion deepseq directory
    filepath time
  ];
  description = "Reading, writing and manipulating \".tar\" archive files.";
  license = stdenv.lib.licenses.bsd3;
}
