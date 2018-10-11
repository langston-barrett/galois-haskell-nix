{ mkDerivation, abcBridge, aig, array, base, cmdargs, containers
, criterion, cryptol-verifier, directory, executable-path, fetchgit
, filepath, haskeline, jvm-parser, lens, mtl, parsec, pretty
, process, QuickCheck, random, saw-core, saw-core-aig, split
, statistics, stdenv, tasty, tasty-ant-xml, tasty-hunit
, tasty-quickcheck, transformers, transformers-compat, vector
##################################################### Added
# nix-shell -p cabal2nix --run "cabal2nix --subpath symbolic https://github.com/GaloisInc/macaw > macaw-symbolic.nix"
, fetchFromGitHub
}:

let
  fromJson = builtins.fromJSON (builtins.readFile ./json/jvm-verifier.json);
  src = fetchFromGitHub {
    inherit (fromJson) rev sha256;
    owner = "GaloisInc";
    repo = "jvm-verifier";
  };
in mkDerivation {

  inherit src;
  enableLibraryProfiling = false;
  enableExecutableProfiling = false;
  doCheck = false;

##################################################### Generated

  pname = "jvm-verifier";
  version = "0.4";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aig array base containers cryptol-verifier directory filepath
    haskeline jvm-parser lens mtl pretty saw-core saw-core-aig split
    transformers transformers-compat vector
  ];
  executableHaskellDepends = [
    abcBridge array base cmdargs containers directory executable-path
    filepath jvm-parser lens mtl parsec pretty transformers
    transformers-compat vector
  ];
  testHaskellDepends = [
    abcBridge array base containers directory filepath haskeline
    jvm-parser lens mtl pretty process QuickCheck random tasty
    tasty-ant-xml tasty-hunit tasty-quickcheck transformers vector
  ];
  benchmarkHaskellDepends = [
    abcBridge array base containers criterion directory filepath
    haskeline jvm-parser lens mtl pretty process QuickCheck random
    statistics tasty tasty-ant-xml tasty-hunit tasty-quickcheck
    transformers vector
  ];
  description = "Symbolic simulator for Java bytecode";
  license = stdenv.lib.licenses.bsd3;
}
